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

  func test__optionalEquatable__isIdenticalEntity_returnsTrue() throws {
    // given
    let cat = Cat(transaction: transaction)

    // when
    let union = try? Union<ClassroomPet>.value(with: cat, in: transaction)

    // then
    expect(union == .case(.Cat(cat))).to(beTrue())
    expect(union == ClassroomPet.Cat(cat)).to(beTrue())
    expect(union == cat).to(beTrue())

    expect(union != .case(.Cat(cat))).to(beFalse())
    expect(union != ClassroomPet.Cat(cat)).to(beFalse())
    expect(union != cat).to(beFalse())
  }

  func test__optionalEquatable__isNotIdenticalEntity_returnsFalse() throws {
    // given
    let cat = Cat(transaction: transaction)
    let cat2 = Cat(transaction: transaction)

    // when
    let union = try? Union<ClassroomPet>.value(with: cat, in: transaction)

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
    expect(classroomPet).to(equal(.case(.Cat(cat))))
  }

  func test__init__givenEntityOfInvalidType_throwsInvalidEntityTypeError() throws {
    // given
    let dog = Dog(transaction: transaction)

    let expectedError = CacheError.Reason
      .invalidEntityType(Dog.self, forAbstractType: Union<ClassroomPet>.self)

    // when
    expect(try Union<ClassroomPet>(dog))
      // then
      .to(throwError(expectedError))
  }

  func test__init__givenUnknownEntity_returnsUnknownCase() throws {
    // given
    let unknownEntity = CacheEntity(transaction: transaction)

    // when
    let classroomPet = try Union<ClassroomPet>(unknownEntity)

    // then
    expect(classroomPet).to(equal(.__unknown(unknownEntity)))
  }

  // MARK: valueWithCacheDataInTransaction Tests

  func test__valueWithCacheDataInTransaction__givenEntityOfValidType_returnsUnionOfType() throws {
    // given
    let cat = Cat(transaction: transaction)

    // when
    let classroomPet = try Union<ClassroomPet>.value(with: cat, in: transaction)

    // then
    expect(classroomPet).to(equal(.case(.Cat(cat))))
  }

  func test__valueWithCacheDataInTransaction__givenEntityOfInvalidType_throwsInvalidEntityError() throws {
    // given
    let dog = Dog(transaction: transaction)

    let expectedError = CacheError.Reason
      .invalidEntityType(Dog.self, forAbstractType: Union<ClassroomPet>.self)

    // when
    expect(try Union<ClassroomPet>.value(with: dog, in: self.transaction))
      // then
      .to(throwError(expectedError))
  }

  func test__valueWithCacheDataInTransaction__givenUnknownEntity_returnsUnknownCase() throws {
    // given
    let unknownEntity = CacheEntity(transaction: transaction)

    // when
    let classroomPet = try Union<ClassroomPet>.value(with: unknownEntity, in: transaction)

    // then
    expect(classroomPet).to(equal(.__unknown(unknownEntity)))
  }

  func test__valueWithCacheDataInTransaction__givenInterfaceWrappingEntityOfValidType_returnsUnionOfType() throws {
    // given
    let cat = Cat(transaction: transaction)
    let pet = try Pet(cat)

    // when
    let classroomPet = try Union<ClassroomPet>.value(with: pet, in: transaction)

    // then
    expect(classroomPet).to(equal(.case(.Cat(cat))))
  }

  func test__valueWithCacheDataInTransaction__givenInterfaceWrappingEntityOfInvalidType_throwsInvalidEntityError() throws {
    // given
    let dog = Dog(transaction: transaction)
    let pet = try Pet(dog)

    // when
    let expectedError = CacheError.Reason
      .invalidEntityType(Dog.self, forAbstractType: Union<ClassroomPet>.self)

    // when
    expect(try Union<ClassroomPet>.value(with: pet, in: self.transaction))
      // then
      .to(throwError(expectedError))
  }

  func test__valueWithCacheDataInTransaction__givenDataDictionaryForEntityOfValidType_returnsUnionOfType() throws {
    // given
    let data: [String: Any] = [
      "__typename": Cat.__typename
    ]

    // when
    let classroomPet = try Union<ClassroomPet>.value(with: data, in: transaction)

    // then
    switch classroomPet {
    case .case(.Cat(_)): break
    default: fail("expected ClassroomPet.Cat")
    }
  }

  func test__valueWithCacheDataInTransaction__givenDataDictionaryForEntityOfInvalidType_throwsInvalidEntityError() throws {
    // given
    let data: [String: Any] = [
      "__typename": Dog.__typename
    ]

    // when
    let expectedError = CacheError.Reason
      .invalidEntityType(Dog.self, forAbstractType: Union<ClassroomPet>.self)

    // then
    // when
    expect(try Union<ClassroomPet>.value(with: data, in: self.transaction))
      // then
      .to(throwError(expectedError))
  }

  func test__valueWithCacheDataInTransaction__givenCacheKeyForEntityOfValidType_returnsUnionOfType() throws {
    // given
    let cat = Cat(transaction: transaction)
    let key = CacheKey("123")
    transaction.cache[key.key] = cat

    // when
    let classroomPet = try Union<ClassroomPet>.value(with: key, in: transaction)

    // then
    expect(classroomPet).to(equal(.case(.Cat(cat))))
  }

  func test__valueWithCacheDataInTransaction__givenCacheKeyForEntityOfInvalidType_throwsInvalidEntityError() throws {
    // given
    let dog = Dog(transaction: transaction)
    let key = CacheKey("123")
    transaction.cache[key.key] = dog

    // when
    let expectedError = CacheError.Reason
      .invalidEntityType(Dog.self, forAbstractType: Union<ClassroomPet>.self)

    // then
    // when
    expect(try Union<ClassroomPet>.value(with: key, in: self.transaction))
      // then
      .to(throwError(expectedError))
  }

  func test__valueWithCacheDataInTransaction__givenScalarType_throwsUnrecognizedCacheDataError() throws {
    // given
    let scalar = "I am a Cat!"

    // when
    let expectedError = CacheError.Reason
      .unrecognizedCacheData(scalar, forType: Union<ClassroomPet>.self)

    // then
    // when
    expect(try Union<ClassroomPet>.value(with: scalar, in: self.transaction))
      // then
      .to(throwError(expectedError))
  }
}
