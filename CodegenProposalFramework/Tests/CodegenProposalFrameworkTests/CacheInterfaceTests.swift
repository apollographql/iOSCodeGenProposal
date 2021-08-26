import XCTest
import Nimble
@testable import CodegenProposalFramework
@testable import AnimalsAPI
@testable import AnimalSchema

class CacheInterfaceTests: XCTestCase {

  var transaction: MockTransaction!

  override func setUp() {
    super.setUp()
    transaction = MockTransaction()
  }

  override func tearDown() {
    transaction = nil
    super.tearDown()
  }

  // MARK: Cache Entity Field

  func test_getCacheEntityField_fromNestedData_createsEntityWithData() throws {
    // given
    let dog = Dog(transaction: transaction)
    dog.data["height"] = [
      "__typename": "Height",
      "meters": 1,
      "feet": 3
    ]


    // when
    let asHousePet = try HousePet(dog)
    let heightEntity = asHousePet.height

    // then
    expect(heightEntity?.meters).to(equal(1))
    expect(heightEntity?.feet).to(equal(3))
  }

  func test_getCacheEntityField_fromCacheKeyReference_getsEntityWithKeyFromCache() throws {
    // given
    let key = CacheKey("123")
    let dog = Dog(transaction: transaction)
    dog.data["bestFriend"] = key

    let bestFriend = Dog(transaction: transaction)
    transaction.cache[key.key] = bestFriend

    // when
    let asHousePet = try HousePet(dog)

    // then
    expect(asHousePet.bestFriend?.entity).to(beIdenticalTo(bestFriend))
  }

  // MARK: Covariant Fields

  func test_setCovariantField_withInterfaceType_toInvalidType_throwsInvalidEntityTypeError() throws {
    let dog = Dog(transaction: transaction)
    let asHousePet = try HousePet(dog)

    let bird = Bird(transaction: transaction)
    let birdAsPet = try Pet(bird)

    let expectedError = CacheError(
      reason: .invalidValue(birdAsPet, forCovariantFieldOfType: HousePet.self),
      type: .write,
      field: "bestFriend",
      object: dog
    )

    asHousePet.bestFriend = birdAsPet

    expect(self.transaction.errors.first).to(equal(expectedError))
    expect(dog.bestFriend).to(beNil())
    expect(asHousePet.bestFriend).to(beNil())
  }

  func test_setCovariantField_withInterfaceType_toValidType_setsFieldOnEntity() throws {
    let dog = Dog(transaction: transaction)
    let asHousePet = try HousePet(dog)

    let bestFriendAsDog = try Pet(Dog(transaction: transaction))

    asHousePet.bestFriend = bestFriendAsDog

    expect(self.transaction.errors).to(beEmpty())
    expect(dog.bestFriend?.entity).to(beIdenticalTo(bestFriendAsDog.entity))
    expect(asHousePet.bestFriend?.entity).to(beIdenticalTo(bestFriendAsDog.entity))
  }

  func test_setCovariantField_withEntityType_toInvalidType_throwsInvalidEntityTypeError() throws {
    let dog = Dog(transaction: transaction)
    let asHousePet = try HousePet(dog)

    let bird = Bird(transaction: transaction)
    let birdAsPet = try Pet(bird)

    let expectedError = CacheError(
      reason: .invalidValue(birdAsPet, forCovariantFieldOfType: Cat.self),
      type: .write,
      field: "rival",
      object: dog
    )

    asHousePet.rival = birdAsPet

    expect(self.transaction.errors.first).to(matchError(expectedError))
    expect(dog.bestFriend).to(beNil())
    expect(asHousePet.bestFriend).to(beNil())
  }

  func test_setCovariantField_withEntityType_toValidType_setsFieldOnEntity() throws {
    let dog = Dog(transaction: transaction)
    let asHousePet = try HousePet(dog)

    let rivalAsPet = try Pet(Cat(transaction: transaction))

    asHousePet.rival = rivalAsPet

    expect(self.transaction.errors).to(beEmpty())
    expect(dog.rival).to(beIdenticalTo(rivalAsPet.entity))
    expect(asHousePet.rival?.entity).to(beIdenticalTo(rivalAsPet.entity))
  }
}
