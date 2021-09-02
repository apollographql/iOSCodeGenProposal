import XCTest
import Nimble
@testable import CodegenProposalFramework
@testable import AnimalsAPI
@testable import AnimalSchema

class ObjectTests: XCTestCase {

  var transaction: MockTransaction!

  override func setUp() {
    super.setUp()
    transaction = MockTransaction()
  }

  override func tearDown() {
    transaction = nil
    super.tearDown()
  }

  // MARK: Init Tests

  func test__init__dataWithTypeName_retainsTypename() throws {
    // given
    let data = [
      "__typename": "Dog",
    ]

    // when
    let dog = Dog(transaction: transaction, data: data)

    // then
    expect(dog.data["__typename"] as? String).to(equal("Dog"))
  }

  func test__init__dataMissingTypeName_setsTypenameToDefaultTypename() throws {
    // when
    let dog = Dog(transaction: transaction, data: [:])

    // then
    expect(dog.data["__typename"] as? String).to(equal("Dog"))
  }

  func test__init__dataMissingTypeName_forUnknownObject_setsTypenameToUnknownTypeName() throws {
    // when
    let dog = Object(transaction: transaction, data: [:])

    // then
    expect(dog.data["__typename"] as? String).to(equal(Object.UnknownTypeName))
  }

  // MARK: Object Field Tests

  func test_getObjectField_fromNestedData_createsObjectWithData() throws {
    // given
    let dog = Dog(transaction: transaction)
    dog.data["height"] = [
      "__typename": "Height",
      "meters": 1,
      "feet": 3
    ]

    // when
    let heightObject = dog.height

    // then
    expect(heightObject?.meters).to(equal(1))
    expect(heightObject?.feet).to(equal(3))
  }

  func test_getObjectField_fromCacheKeyReference_getsObjectWithKeyFromCache() throws {
    // given
    let key = CacheKey("123")
    let dog = Dog(transaction: transaction)

    let bestFriend = Dog(transaction: transaction)

    transaction.cache[key.key] = bestFriend

    // when
    dog.data["bestFriend"] = key

    // then
    expect(dog.bestFriend?.object).to(beIdenticalTo(bestFriend))
  }
}
