import XCTest
@testable import CodegenProposalFramework
@testable import AnimalsAPI
@testable import AnimalSchema

class AnimalSchemaTests: XCTestCase {

  func test_covariantInterfaceImplementation() throws {
    let dog = Dog()
    dog.predators = [Dog(), Dog()]
    XCTAssertEqual(dog.predators.count, 2)

    let animal: Animal = dog
    XCTAssertEqual(animal.predators.count, 2)
  }

}
