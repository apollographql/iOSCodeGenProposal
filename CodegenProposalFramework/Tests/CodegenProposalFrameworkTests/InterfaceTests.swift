import XCTest
import Nimble
@testable import CodegenProposalFramework
@testable import AnimalsAPI
@testable import AnimalSchema

class InterfaceTests: XCTestCase {

  var transaction: MockTransaction!

  override func setUp() {
    super.setUp()
    transaction = MockTransaction()
  }

  override func tearDown() {
    transaction = nil
    super.tearDown()
  }

  // MARK: Object Field

  func test_getObjectField_fromNestedData_createsObjectWithData() throws {
    // given
    let dog = Dog(transaction: transaction)
    dog.data["height"] = [
      "__typename": "Height",
      "meters": 1,
      "feet": 3
    ]


    // when
    let asHousePet = try HousePet(dog)
    let heightObject = asHousePet.height

    // then
    expect(heightObject?.meters).to(equal(1))
    expect(heightObject?.feet).to(equal(3))
  }

  func test_getObjectField_fromCacheKeyReference_getsObjectWithKeyFromCache() throws {
    // given
    let key = CacheKey("123")
    let dog = Dog(transaction: transaction)
    dog.data["bestFriend"] = key

    let bestFriend = Dog(transaction: transaction)
    transaction.cache[key.key] = bestFriend

    // when
    let asHousePet = try HousePet(dog)

    // then
    expect(asHousePet.bestFriend?.object).to(beIdenticalTo(bestFriend))
  }

  // MARK: Covariant Fields

  func test_setCovariantField_withInterfaceType_toInvalidType_throwsInvalidValueForCovariantFieldError() throws {
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

  func test_setCovariantField_withInterfaceType_toValidType_setsFieldOnObject() throws {
    let dog = Dog(transaction: transaction)
    let asHousePet = try HousePet(dog)

    let bestFriendAsDog = try Pet(Dog(transaction: transaction))

    asHousePet.bestFriend = bestFriendAsDog

    expect(self.transaction.errors).to(beEmpty())
    expect(dog.bestFriend?.object).to(beIdenticalTo(bestFriendAsDog.object))
    expect(asHousePet.bestFriend?.object).to(beIdenticalTo(bestFriendAsDog.object))
  }

  func test_setCovariantField_withObjectType_toInvalidType_throwsInvalidValueForCovariantFieldError() throws {
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

  func test_setCovariantField_withObjectType_toValidType_setsFieldOnObject() throws {
    let dog = Dog(transaction: transaction)
    let asHousePet = try HousePet(dog)

    let rivalAsPet = try Pet(Cat(transaction: transaction))

    asHousePet.rival = rivalAsPet

    expect(self.transaction.errors).to(beEmpty())
    expect(dog.rival).to(beIdenticalTo(rivalAsPet.object))
    expect(asHousePet.rival?.object).to(beIdenticalTo(rivalAsPet.object))
  }

  func test_setCovariantField_withUnionType_toInvalidType_throwsInvalidValueForCovariantFieldError() throws {
    let dog = Dog(transaction: transaction)
    let asHousePet = try HousePet(dog)

    let cat = Cat(transaction: transaction)
    let catAsClassroomPet = try Union<ClassroomPet>(cat)

    let expectedError = CacheError(
      reason: .invalidValue(catAsClassroomPet, forCovariantFieldOfType: Bird.self),
      type: .write,
      field: "livesWith",
      object: dog
    )

    asHousePet.livesWith = catAsClassroomPet

    expect(self.transaction.errors.first).to(matchError(expectedError))
    expect(dog.livesWith).to(beNil())
    expect(asHousePet.livesWith).to(beNil())
  }

  func test_setCovariantField_withUnionType_toValidType_setsFieldOnObject() throws {
    let dog = Dog(transaction: transaction)
    let asHousePet = try HousePet(dog)

    let bird = Bird(transaction: transaction)
    let birdAsClassroomPet = try Union<ClassroomPet>(bird)

    asHousePet.livesWith = birdAsClassroomPet

    expect(self.transaction.errors).to(beEmpty())
    expect(dog.livesWith).to(beIdenticalTo(bird))
    expect(asHousePet.livesWith?.object).to(beIdenticalTo(bird))
  }
}
