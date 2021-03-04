//
//  Tests_iOS.swift
//  Tests iOS
//
//  Created by Anthony Miller on 1/25/21.
//

import XCTest
@testable import CodegenProposalFramework

class SanityCheckTests: XCTestCase {

  var data: ResponseData!

  override func setUpWithError() throws {
    try super.setUpWithError()

    data = ResponseData(data: [
      "__typename": "Cat",
      "species": "Cat",
      "height": [
        "__typename": "Height",
        "feet": 2,
        "inches": 7,
        "meters": 10,
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
          "hasFur": true
        ],
        [
          "__typename": "Crocodile",
          "species": "Crocodile",
        ]
      ],
      "humanName": "Tiger Lily",
      "favoriteToy": "Shoelaces",
      "bodyTemperature": 98
    ])
  }

  override func tearDownWithError() throws {
    try super.tearDownWithError()
  }

  func testSpecies() throws {
    let cat = Animal(data: data)

    XCTAssertEqual(cat.species, "Cat")
  }

  func testAsTypeCondition_fieldOnTypeNested2TypeConditionsDeep() throws {
    let subject = Animal(data: data)

    XCTAssertEqual(subject.species, "Cat")
    XCTAssertEqual(subject.asPet?.species, "Cat")
    XCTAssertEqual(subject.asPet?.asWarmBlooded?.species, "Cat")
  }

  func testAsTypeConditions_withDuplicateFieldOnParent() throws {
    let subject = Animal(data: data)    

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
    let subject = Animal(data: data)

    XCTAssertEqual(subject.fragments.heightInMeters.height.meters, 10)

    XCTAssertEqual(subject.asWarmBlooded?.fragments.heightInMeters.height.meters, 10)
    XCTAssertEqual(subject.asWarmBlooded?.fragments.warmBloodedDetails.height.meters, 10)

    XCTAssertEqual(subject.asPet?.fragments.heightInMeters.height.meters, 10)
    XCTAssertEqual(subject.asPet?.fragments.petDetails.favoriteToy, "Shoelaces")

    XCTAssertEqual(subject.asPet?.asWarmBlooded?.fragments.heightInMeters.height.meters, 10)
    XCTAssertEqual(subject.asPet?.asWarmBlooded?.fragments.warmBloodedDetails.height.meters, 10)
    XCTAssertEqual(subject.asPet?.asWarmBlooded?.fragments.petDetails.favoriteToy, "Shoelaces")
  }

  func testListField() {
    let subject = Animal(data: data)
    let coyote = subject.predators[0]
    let crocodile = subject.predators[1]

    XCTAssertEqual(coyote.species, "Coyote")
    XCTAssertEqual(coyote.asWarmBlooded?.bodyTemperature, 96)
    XCTAssertEqual(coyote.asWarmBlooded?.height.meters, 3)
    XCTAssertEqual(coyote.asWarmBlooded?.height.yards, 1)
    XCTAssertEqual(coyote.asWarmBlooded?.hasFur, true)

    XCTAssertEqual(crocodile.species, "Crocodile")
  }

}
