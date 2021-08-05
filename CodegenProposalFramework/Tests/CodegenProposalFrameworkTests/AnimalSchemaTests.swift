import XCTest
@testable import CodegenProposalFramework
@testable import AnimalsAPI
@testable import AnimalSchema

class AnimalSchemaTests: XCTestCase {

  func test_covariantInterfaceImplementation() throws {
    let dog = Dog(in: MockTransaction())
    dog.species = "Canine"
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
      "Test": 1
    ]

    let bestFriend = dog.bestFriend
    XCTAssertEqual(bestFriend?.data["Test"] as? Int, 1)
  }

}

class MockTransaction: CacheTransaction {

  let entityFactory: CacheEntityFactory.Type = AnimalSchema.TypesUsed.self

  init() {}

  func entity<T: CacheEntity>(withKey: String) -> T? {
    return nil
  }
}
