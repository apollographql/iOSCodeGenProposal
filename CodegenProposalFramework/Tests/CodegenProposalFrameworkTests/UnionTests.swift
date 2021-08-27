import XCTest
import Nimble
@testable import CodegenProposalFramework
@testable import AnimalsAPI
@testable import AnimalSchema

class UnionTests: XCTestCase {

  var transaction: MockTransaction!

  override func setUp() {
    super.setUp()
    transaction = MockTransaction()
  }

  override func tearDown() {
    transaction = nil
    super.tearDown()
  }

  func test__Equatable__isIdenticalEntity_returnsTrue() throws {
    // given
    let cat = Cat(transaction: transaction)

    // when
    let union = try Union<ClassroomPet>.value(with: cat, in: transaction)

    // then
    expect(union == .case(.Cat(cat))).to(beTrue())
    expect(union == ClassroomPet.Cat(cat)).to(beTrue())
    expect(union == cat).to(beTrue())

    expect(union != .case(.Cat(cat))).to(beFalse())
    expect(union != ClassroomPet.Cat(cat)).to(beFalse())
    expect(union != cat).to(beFalse())
  }

  func test__Equatable__isNotIdenticalEntity_returnsFalse() throws {
    // given
    let cat = Cat(transaction: transaction)
    let cat2 = Cat(transaction: transaction)

    // when
    let union = try Union<ClassroomPet>.value(with: cat, in: transaction)

    // then
    expect(union == .case(.Cat(cat2))).to(beFalse())
    expect(union == ClassroomPet.Cat(cat2)).to(beFalse())
    expect(union == cat2).to(beFalse())

    expect(union != .case(.Cat(cat2))).to(beTrue())
    expect(union != ClassroomPet.Cat(cat2)).to(beTrue())
    expect(union != cat2).to(beTrue())
  }

  func test__patternMatching__matchesCasesWithIdenticalEntity() throws {
    // given
    let cat = Cat(transaction: transaction)

    // when
    let union = try Union<ClassroomPet>.value(with: cat, in: transaction)

    // then

    switch union {
    case .Cat(cat): break
    case .Cat(Cat(transaction: transaction)): fail()
    default: fail()
    }

    switch union.value {
    case let .Cat(catValue): expect(catValue).to(beIdenticalTo(cat))
    default: fail()
    }
  }

  // MARK: Initializer Tests

  func test__init__givenEntityOfValidType_returnsUnionOfType() throws {
    // given
    let cat = Cat(transaction: transaction)

    // when
    let classroomPet = try Union<ClassroomPet>(cat)

    // then
    expect(classroomPet).toNot(beNil())
    expect(classroomPet).to(equal(.case(.Cat(cat))))
  }

  func test__init__givenEntityOfInvalidType_throws() throws {
    // given
    let dog = Dog(transaction: transaction)

    let expectedError = CacheError.Reason
      .invalidEntityType(Dog.self, forAbstractType: Union<ClassroomPet>.self)

    // when
    expect(try Union<ClassroomPet>(dog))
      // then
      .to(throwError(expectedError))
  }

//  func test__init__givenEntityOfTypeUnknownToSchema_throws() throws {
//    // given
//    let unknownEntity = CacheEntity(transaction: transaction, data: ["__typename": ])
//
//    let expectedError = CacheError.Reason
//      .invalidEntityType(Dog.self, forAbstractType: Union<ClassroomPet>.self)
//
//    // when
//    expect(try Union<ClassroomPet>(dog))
//      // then
//      .to(throwError(expectedError))
//  }

  // MARK: valueWithCacheDataInTransaction Tests

  func test__valueWithCacheDataInTransaction__givenEntityOfValidType_returnsUnionOfType() throws {
    // given
    let cat = Cat(transaction: transaction)

    // when
    let classroomPet = try Union<ClassroomPet>.value(with: cat, in: transaction)

    // then
    expect(classroomPet).toNot(beNil())
    expect(classroomPet).to(equal(.case(.Cat(cat))))
  }

  func test__valueWithCacheDataInTransaction__givenEntityOfInvalidType_throws() throws {
    // given
    let dog = Dog(transaction: transaction)

    let expectedError = CacheError.Reason
      .invalidEntityType(Dog.self, forAbstractType: Union<ClassroomPet>.self)

    // when
    expect(try Union<ClassroomPet>.value(with: dog, in: self.transaction))
      // then
      .to(throwError(expectedError))
  }
  
}
