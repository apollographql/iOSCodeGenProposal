import XCTest
@testable import CodegenProposalFramework
@testable import AnimalsAPI
@testable import AnimalSchema

class AnimalSchemaTests: XCTestCase {

  func test_covariantInterfaceImplementation() throws {
    let dog = Dog(in: MockTransaction())
    dog.predators = [Dog(in: MockTransaction()), Dog(in: MockTransaction())]
    XCTAssertEqual(dog.predators.count, 2)

    let animal: Animal = dog
    XCTAssertEqual(animal.predators.count, 2)

//    animal.predators = [Dog(in: MockTransaction())]
//    XCTAssertEqual(animal.predators.count, 1)
  }

  func test_initCacheEntityFromNestedData() throws {
    let dog = Dog(in: MockTransaction())
    dog.data["bestFriend"] = [
      "__typename": "Dog",
      "Test": 1,
      "bodyTemperature": 12
    ]

    let bestFriend = dog.bestFriend?.resolve()
    XCTAssertEqual(bestFriend?.data["Test"] as? Int, 1)
    XCTAssertEqual(bestFriend?.bodyTemperature, 12)
  }

  func test_initCacheEntityFromCacheKeyReference() throws {
    // given
    let key = CacheKey(key: "$123")
    let transaction = MockTransaction()

    let bestFriendData: [String: Any] = [
      "__typename": "Dog",
      "Test": 1
    ]

    transaction.cache[key.key] = bestFriendData

    // when
    let dog = Dog(in: MockTransaction())
    dog.data["bestFriend"] = key

    // then
//    let bestFriend = dog.bestFriend?.resolve()
//    XCTAssertEqual(bestFriend?.data["Test"] as? Int, 1)
  }

}

class MockTransaction: CacheTransaction {

  var cache: [String: Any] = [:]

  let entityFactory: CacheEntityFactory.Type = AnimalSchema.TypesUsed.self

  init() {}

  func entity<T>(withKey: String) -> T? {
    return nil
  }

  func cacheKey(for: CacheEntity) -> CacheKey? {
    return nil
  }
}
