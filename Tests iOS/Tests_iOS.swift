//
//  Tests_iOS.swift
//  Tests iOS
//
//  Created by Anthony Miller on 1/25/21.
//

import XCTest
@testable import CodegenProposalFramework

class Tests_iOS: XCTestCase {

  override func setUpWithError() throws {
    try super.setUpWithError()
  }

  override func tearDownWithError() throws {
    try super.tearDownWithError()
  }

  func testSpecies() throws {
    let cat = Animal(__typename: "Cat",
                     species: "Cat",
                     height: .init(fields: .init(__typename: "Height", feet: 2, inches: 10, meters: 4)),
                     predators: [])
    XCTAssertEqual(cat.species, "Cat")
  }

  func testSpecies_onTypeNested2TypeCasesDeep() throws {
    let cat = Animal( // TODO: have to retain this for nested weak type case
      __typename: "Cat",
      species: "Cat",
      height: .init(fields: .init(__typename: "Height", feet: 2, inches: 7, meters: 10)),
      predators: []
    )
    .makeAsPet(humanName: "Tiger Lily", favoriteToy: "Shoelaces")
    .makeAsWarmBlooded(bodyTemperature: 98, height: .init(fields: .init(meters: 10, yards: 3)))

    XCTAssertEqual(cat.species, "Cat")
    XCTAssertEqual(cat.parent.parent.asPet?.species, "Cat")
    XCTAssertEqual(cat.parent.parent.asPet?.asWarmBlooded?.species, "Cat")
  }

  func testAsTypeFragment_withDuplicateFieldOnParent() throws {
    let asWarmBloodedPet = Animal( // TODO: have to retain this for nested weak type case
      __typename: "Cat",
      species: "Cat",
      height: .init(fields: .init(__typename: "Height", feet: 2, inches: 7, meters: 10)),
      predators: []
    )
    .makeAsWarmBlooded(bodyTemperature: 98, height: .init(fields: .init(meters: 10, yards: 3)))
    .parent
    .makeAsPet(humanName: "Tiger Lily", favoriteToy: "Shoelaces")
    .makeAsWarmBlooded(bodyTemperature: 98, height: .init(fields: .init(meters: 10, yards: 3)))

    let subject = asWarmBloodedPet.parent.parent

    XCTAssertEqual(subject.height.feet, 2)
    XCTAssertEqual(subject.height.inches, 7)
    XCTAssertEqual(subject.height.meters, 10)
    XCTAssertEqual(subject.asWarmBlooded?.height.feet, 2)
    XCTAssertEqual(subject.asWarmBlooded?.height.inches, 7)
    XCTAssertEqual(subject.asWarmBlooded?.height.meters, 10)
    XCTAssertEqual(subject.asWarmBlooded?.height.yards, 3)
    XCTAssertEqual(subject.asPet?.asWarmBlooded?.height.feet, 2)
    XCTAssertEqual(subject.asPet?.asWarmBlooded?.height.inches, 7)
    XCTAssertEqual(subject.asPet?.asWarmBlooded?.height.meters, 10)
    XCTAssertEqual(subject.asPet?.asWarmBlooded?.height.yards, 3)
  }

  func testAsTypeFragment_withFragmentsOnParent_convertToFragments() throws {
    let asWarmBloodedPet = Animal( // TODO: have to retain this for nested weak type case
      __typename: "Cat",
      species: "Cat",
      height: .init(fields: .init(__typename: "Height", feet: 2, inches: 7, meters: 10)),
      predators: []
    )
    .makeAsWarmBlooded(bodyTemperature: 98, height: .init(fields: .init(meters: 10, yards: 3)))
    .parent
    .makeAsPet(humanName: "Tiger Lily", favoriteToy: "Shoelaces")
    .makeAsWarmBlooded(bodyTemperature: 98, height: .init(fields: .init(meters: 10, yards: 3)))

    let subject = asWarmBloodedPet.parent.parent

    XCTAssertEqual(subject.fragments.heightInMeters.height.meters, 10)

    XCTAssertEqual(subject.asWarmBlooded?.fragments.heightInMeters.height.meters, 10)
    XCTAssertEqual(subject.asWarmBlooded?.fragments.warmBloodedDetails.height.meters, 10)

    XCTAssertEqual(subject.asPet?.fragments.heightInMeters.height.meters, 10)
    XCTAssertEqual(subject.asPet?.fragments.petDetails.favoriteToy, "Shoelaces")

    XCTAssertEqual(subject.asPet?.asWarmBlooded?.fragments.heightInMeters.height.meters, 10)
    XCTAssertEqual(subject.asPet?.asWarmBlooded?.fragments.warmBloodedDetails.height.meters, 10)
    XCTAssertEqual(subject.asPet?.asWarmBlooded?.fragments.petDetails.favoriteToy, "Shoelaces")
  }

}
