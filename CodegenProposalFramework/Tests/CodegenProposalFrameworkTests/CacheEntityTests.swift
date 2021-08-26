import XCTest
import Nimble
@testable import CodegenProposalFramework
@testable import AnimalsAPI
@testable import AnimalSchema

class CacheEntityTests: XCTestCase {

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
      let heightEntity = dog.height

      // then
      expect(heightEntity?.meters).to(equal(1))
      expect(heightEntity?.feet).to(equal(3))
    }

    func test_getCacheEntityField_fromCacheKeyReference_getsEntityWithKeyFromCache() throws {
      // given
      let key = CacheKey("123")
      let dog = Dog(transaction: transaction)

      let bestFriend = Dog(transaction: transaction)

      transaction.cache[key.key] = bestFriend

      // when
      dog.data["bestFriend"] = key

      // then
      expect(dog.bestFriend?.entity).to(beIdenticalTo(bestFriend))
    }
}
