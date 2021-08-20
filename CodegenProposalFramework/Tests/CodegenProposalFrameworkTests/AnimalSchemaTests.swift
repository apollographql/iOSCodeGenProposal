import XCTest
@testable import CodegenProposalFramework
@testable import AnimalsAPI
@testable import AnimalSchema

class AnimalSchemaTests: XCTestCase {

  var transaction: MockTransaction!

  override func setUp() {
    super.setUp()
    transaction = MockTransaction()
  }

  override func tearDown() {
    transaction = nil
    super.tearDown()
  }

  func test_setCovariantFieldOnInterfaceToInvalidType() throws {
    let dog = Dog(transaction: transaction)
    let asHousePet = HousePet(entity: dog)

    let bird = Bird(transaction: transaction)
    let birdAsPet = Pet(entity: bird)

    asHousePet.bestFriend = birdAsPet

    XCTAssert(transaction.errors.count == 1)
    XCTAssertNil(dog.bestFriend)
    XCTAssertNil(asHousePet.bestFriend)
  }

//  func test_initCacheEntityFromNestedData() throws {
//    let dog = makeDog()
//    dog.data["bestFriend"] = [
//      "__typename": "Dog",
//      "Test": 1,
//      "bodyTemperature": 12
//    ]
//
//    let bestFriend = dog.bestFriend?.resolve()
//    XCTAssertEqual(bestFriend?.data["Test"] as? Int, 1)
//    XCTAssertEqual(bestFriend?.bodyTemperature, 12)
//  }
//
//  func test_initCacheEntityFromCacheKeyReference() throws {
//    // given
//    let key = CacheKey(key: "$123")
//    let transaction = MockTransaction()
//
//    let bestFriendData: [String: Any] = [
//      "__typename": "Dog",
//      "Test": 1
//    ]
//
//    transaction.cache[key.key] = bestFriendData
//
//    // when
//    let dog = Dog(in: MockTransaction())
//    dog.data["bestFriend"] = key
//
//    // then
////    let bestFriend = dog.bestFriend?.resolve()
////    XCTAssertEqual(bestFriend?.data["Test"] as? Int, 1)
//  }

}

class MockTransaction: CacheTransaction {

  var cache: [String: Any] = [:]

  init() {
    super.init(entityFactory: AnimalSchema.TypesUsed.self, keyResolver: MockCacheKeyResolver())
  }

  func entity<T>(withKey: String) -> T? {
    return nil
  }
}

struct MockCacheKeyResolver: CacheKeyResolver {
  func cacheKey(for: [String : Any]) -> CacheKey? {
    return nil
  }
}
