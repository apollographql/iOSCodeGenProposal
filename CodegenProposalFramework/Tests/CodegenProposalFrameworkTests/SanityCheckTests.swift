//
//  Tests_iOS.swift
//  Tests iOS
//
//  Created by Anthony Miller on 1/25/21.
//

import XCTest
@testable import CodegenProposalFramework
@testable import AnimalsAPI
@testable import AnimalSchema

class SanityCheckTests: XCTestCase {

  var data: ResponseDict!
  var dataDict: [String: Any]!

  override func setUpWithError() throws {
    try super.setUpWithError()

    dataDict = [
      "__typename": "Cat",
      "species": "Cat",
      "height": [
        "__typename": "Height",
        "feet": 2,
        "inches": 7,
        "meters": 10,
        "relativeSize": "SMALL",
        "centimeters": 1000,
        "yards": 3
      ],
      "predators": [
        [
          "__typename": "Coyote",
          "species": "Coyote",
          "bodyTemperature": 96,
          "height": [
            "__typename": "Height",
            "meters": 3,
            "yards": 1
          ],
          "laysEggs": false
        ],
        [
          "__typename": "Crocodile",
          "species": "Crocodile",
        ]
      ],
      "skinCovering": "FUR",
      "humanName": "Tiger Lily",
      "favoriteToy": "Shoelaces",
      "bodyTemperature": 98,
      "isJellical": true,
      "owner": [
        "__typename": "Human",
        "firstName": "Hugh"
      ]
    ]

    data = ResponseDict(data: dataDict)
  }

  override func tearDownWithError() throws {
    try super.tearDownWithError()
  }

  func testSpecies() throws {
    let cat = AllAnimalsQuery.ResponseData.Animal(data: data)

    XCTAssertEqual(cat.species, "Cat")
  }

  func testAsTypeCondition_fieldOnTypeNested2TypeConditionsDeep() throws {
    let subject = AllAnimalsQuery.ResponseData.Animal(data: data)

    XCTAssertEqual(subject.species, "Cat")
    XCTAssertEqual(subject.asPet?.species, "Cat")
    XCTAssertEqual(subject.asPet?.asWarmBlooded?.species, "Cat")
  }

  func testAsTypeConditions_withDuplicateFieldOnParent() throws {
    let subject = AllAnimalsQuery.ResponseData.Animal(data: data)

    XCTAssertEqual(subject.species, "Cat")
    XCTAssertEqual(subject.height.feet, 2)
    XCTAssertEqual(subject.height.inches, 7)
    XCTAssertEqual(subject.height.meters, 10)
    XCTAssertEqual(subject.predators.count, 2)

    XCTAssertEqual(subject.asWarmBlooded?.species, "Cat")
    XCTAssertEqual(subject.asWarmBlooded?.height.feet, 2)
    XCTAssertEqual(subject.asWarmBlooded?.height.inches, 7)
    XCTAssertEqual(subject.asWarmBlooded?.height.meters, 10)
    XCTAssertEqual(subject.asWarmBlooded?.predators.count, 2)
    XCTAssertEqual(subject.asWarmBlooded?.height.yards, 3)
    XCTAssertEqual(subject.asWarmBlooded?.bodyTemperature, 98)

    XCTAssertEqual(subject.asPet?.species, "Cat")
    XCTAssertEqual(subject.asPet?.height.feet, 2)
    XCTAssertEqual(subject.asPet?.height.inches, 7)
    XCTAssertEqual(subject.asPet?.height.meters, 10)
    XCTAssertEqual(subject.asPet?.predators.count, 2)
    XCTAssertEqual(subject.asPet?.height.centimeters, 1000)
    XCTAssertEqual(subject.asPet?.height.relativeSize, .case(.SMALL))
    XCTAssertEqual(subject.asPet?.humanName, "Tiger Lily")
    XCTAssertEqual(subject.asPet?.favoriteToy, "Shoelaces")

    XCTAssertEqual(subject.asPet?.asWarmBlooded?.species, "Cat")
    XCTAssertEqual(subject.asPet?.asWarmBlooded?.height.feet, 2)
    XCTAssertEqual(subject.asPet?.asWarmBlooded?.height.inches, 7)
    XCTAssertEqual(subject.asPet?.asWarmBlooded?.height.meters, 10)
    XCTAssertEqual(subject.asPet?.asWarmBlooded?.predators.count, 2)
    XCTAssertEqual(subject.asPet?.asWarmBlooded?.height.centimeters, 1000)
    XCTAssertEqual(subject.asPet?.asWarmBlooded?.height.yards, 3)
    XCTAssertEqual(subject.asPet?.asWarmBlooded?.humanName, "Tiger Lily")
    XCTAssertEqual(subject.asPet?.asWarmBlooded?.favoriteToy, "Shoelaces")
    XCTAssertEqual(subject.asPet?.asWarmBlooded?.bodyTemperature, 98)    
  }

  func testAsTypeCondition_withFragmentsOnParent_convertToFragments() throws {
    let subject = AllAnimalsQuery.ResponseData.Animal(data: data)

    XCTAssertEqual(subject.fragments.heightInMeters.height.meters, 10)

    XCTAssertEqual(subject.asWarmBlooded?.fragments.heightInMeters.height.meters, 10)
    XCTAssertEqual(subject.asWarmBlooded?.fragments.warmBloodedDetails.height.meters, 10)

    XCTAssertEqual(subject.asPet?.fragments.heightInMeters.height.meters, 10)
    XCTAssertEqual(subject.asPet?.fragments.petDetails.favoriteToy, "Shoelaces")

    XCTAssertEqual(subject.asPet?.asWarmBlooded?.fragments.heightInMeters.height.meters, 10)
    XCTAssertEqual(subject.asPet?.asWarmBlooded?.fragments.warmBloodedDetails.height.meters, 10)
    XCTAssertEqual(subject.asPet?.asWarmBlooded?.fragments.petDetails.favoriteToy, "Shoelaces")
  }

  func testAsTypeConditionForInterface_withConcreteTypeThatDoesNotImplementInterface() throws {
    dataDict["__typename"] = AnimalSchema.ObjectType.Fish.rawValue
    data = ResponseDict(data: dataDict)
    let subject = AllAnimalsQuery.ResponseData.Animal(data: data)

    XCTAssertNil(subject.asWarmBlooded)
    XCTAssertNotNil(subject.asPet)
  }

  func testAsTypeConditionForConcreteType_withDifferentConcreteType() throws {
    dataDict["__typename"] = AnimalSchema.ObjectType.Fish.rawValue
    data = ResponseDict(data: dataDict)
    let subject = AllAnimalsQuery.ResponseData.Animal(data: data)

    XCTAssertNil(subject.asCat)
  }

  func testAsTypeConditionForConcreteType_withMatchingConcreteType() throws {
    let subject = AllAnimalsQuery.ResponseData.Animal(data: data)

    XCTAssertNotNil(subject.asCat)
  }

  func testAsTypeConditionForUnionType_withConcreteTypeMatchingAMemberType() throws {
    dataDict["__typename"] = AnimalSchema.ObjectType.Bird.rawValue
    dataDict["wingspan"] = 15
    data = ResponseDict(data: dataDict)
    let subject = AllAnimalsQuery.ResponseData.Animal(data: data)

    let asClassroomPet = subject.asClassroomPet
    XCTAssertNotNil(asClassroomPet)
    XCTAssertEqual(asClassroomPet?.asBird?.wingspan, 15)
  }

  func testAsTypeConditionForUnionType_withConcreteTypeNotMatchingAMemberType() throws {
    dataDict["__typename"] = AnimalSchema.ObjectType.Crocodile.rawValue
    data = ResponseDict(data: dataDict)
    let subject = AllAnimalsQuery.ResponseData.Animal(data: data)

    let asClassroomPet = subject.asClassroomPet
    XCTAssertNil(asClassroomPet)    
  }

  func testListField() throws {
    let subject = AllAnimalsQuery.ResponseData.Animal(data: data)
    let coyote = subject.predators[0]
    let crocodile = subject.predators[1]

    XCTAssertEqual(coyote.species, "Coyote")
    XCTAssertEqual(coyote.asWarmBlooded?.bodyTemperature, 96)
    XCTAssertEqual(coyote.asWarmBlooded?.height.meters, 3)
    XCTAssertEqual(coyote.asWarmBlooded?.height.yards, 1)
    XCTAssertEqual(coyote.asWarmBlooded?.laysEggs, false)

    XCTAssertEqual(crocodile.species, "Crocodile")
  }

  func testEnumField_withKnownValue() throws {
    let subject = AllAnimalsQuery.ResponseData.Animal(data: data)

    XCTAssertEqual(subject.skinCovering, GraphQLEnum(SkinCovering.FUR))
    XCTAssertEqual(
      subject.skinCovering,
      GraphQLEnum<SkinCovering>.__unknown(SkinCovering.FUR.rawValue)
    )
    XCTAssertEqual(
      GraphQLEnum<SkinCovering>.__unknown(SkinCovering.FUR.rawValue),
      GraphQLEnum<SkinCovering>.__unknown(SkinCovering.FUR.rawValue)
    )
    XCTAssertNotEqual(
      GraphQLEnum<SkinCovering>.__unknown(SkinCovering.FUR.rawValue),
      GraphQLEnum<SkinCovering>.__unknown("UNKNOWN")
    )
    XCTAssertEqual(subject.skinCovering?.value, .FUR)
    XCTAssertNotEqual(subject.skinCovering?.value, .FEATHERS)
    XCTAssertEqual(subject.skinCovering?.rawValue, SkinCovering.FUR.rawValue)
    XCTAssertTrue(subject.skinCovering == .FUR)
    XCTAssertFalse(subject.skinCovering != .FUR)
    XCTAssertFalse(subject.skinCovering == .FEATHERS)
    XCTAssertTrue(subject.skinCovering != .FEATHERS)
  }

  func testEnumField_withUnknownValue() throws {
    dataDict["skinCovering"] = "TEST_UNKNOWN"
    data = ResponseDict(data: dataDict)
    let subject = AllAnimalsQuery.ResponseData.Animal(data: data)

    XCTAssertNotEqual(subject.skinCovering, GraphQLEnum(SkinCovering.FUR))
    XCTAssertNotEqual(
      subject.skinCovering,
      GraphQLEnum<SkinCovering>.__unknown(SkinCovering.FUR.rawValue)
    )
    XCTAssertEqual(
      subject.skinCovering,
      GraphQLEnum<SkinCovering>.__unknown("TEST_UNKNOWN")
    )
    XCTAssertNotEqual(
      subject.skinCovering,
      GraphQLEnum<SkinCovering>.__unknown("OTHER_UNKNOWN")
    )
    XCTAssertNotEqual(
      subject.skinCovering,
      GraphQLEnum<SkinCovering>.__unknown(SkinCovering.FUR.rawValue)
    )

    XCTAssertNil(subject.skinCovering?.value)
    XCTAssertEqual(subject.skinCovering?.rawValue, "TEST_UNKNOWN")

    XCTAssertFalse(subject.skinCovering == .FUR)
    XCTAssertTrue(subject.skinCovering != .FUR)
    XCTAssertFalse(subject.skinCovering == .FEATHERS)
    XCTAssertTrue(subject.skinCovering != .FEATHERS)
  }

  func testOptionalScalarField_withValue() throws {
    dataDict["humanName"] = "Anastasia"
    data = ResponseDict(data: dataDict)
    let subject = AllAnimalsQuery.ResponseData.Animal(data: data)

    XCTAssertEqual(subject.asPet?.humanName, "Anastasia")
  }

  func testOptionalScalarField_withNilValue() throws {
    dataDict["humanName"] = nil
    data = ResponseDict(data: dataDict)
    let subject = AllAnimalsQuery.ResponseData.Animal(data: data)

    XCTAssertNil(subject.asPet?.humanName)
  }

  func testOptionalScalarField_withNullValue() throws {
    dataDict["humanName"] = NSNull()
    data = ResponseDict(data: dataDict)
    let subject = AllAnimalsQuery.ResponseData.Animal(data: data)

    XCTAssertNil(subject.asPet?.humanName)
  }

  func testOptionalNestedTypeField_withValue() throws {
    dataDict["owner"] = [
      "__typename": "Human",
      "firstName": "Hugh"
    ]
    data = ResponseDict(data: dataDict)
    let subject = AllAnimalsQuery.ResponseData.Animal(data: data)

    XCTAssertEqual(subject.asPet?.owner?.firstName, "Hugh")
  }

  func testOptionalNestedTypeField_withNilValue() throws {
    dataDict["owner"] = nil
    data = ResponseDict(data: dataDict)
    let subject = AllAnimalsQuery.ResponseData.Animal(data: data)

    XCTAssertNil(subject.asPet?.owner)
  }

  func testOptionalNestedTypeField_withNullValue() throws {
    dataDict["owner"] = NSNull()
    data = ResponseDict(data: dataDict)
    let subject = AllAnimalsQuery.ResponseData.Animal(data: data)

    XCTAssertNil(subject.asPet?.owner)
  }

  func testOptionalEnumField_withValue() throws {
    dataDict["skinCovering"] = "FUR"
    data = ResponseDict(data: dataDict)
    let subject = AllAnimalsQuery.ResponseData.Animal(data: data)

    XCTAssertEqual(subject.skinCovering, GraphQLEnum(SkinCovering.FUR))
  }

  func testOptionalEnumField_withNilValue() throws {
    dataDict["skinCovering"] = nil
    data = ResponseDict(data: dataDict)
    let subject = AllAnimalsQuery.ResponseData.Animal(data: data)

    XCTAssertNil(subject.skinCovering)
  }

  func testOptionalEnumField_withNullValue() throws {
    dataDict["skinCovering"] = NSNull()
    data = ResponseDict(data: dataDict)
    let subject = AllAnimalsQuery.ResponseData.Animal(data: data)

    XCTAssertNil(subject.skinCovering)
  }
}
