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
                         height: .init(props: .init(__typename: "Height", feet: 2, inches: 10, meters: 4)))
    XCTAssertEqual(cat.species, "Cat")
  }

  func testAsTypeFragment_withDuplicateFieldOnParent() throws {
    let subject = Animal(__typename: "Cat",
                         species: "Cat",
                         height: .init(props: .init(__typename: "Height", feet: 2, inches: 10, meters: 10)))
      .makeAsWarmBlooded(bodyTemperature: 98, height: .init(props: .init(meters: 10, yards: 3))).parent

    XCTAssertEqual(subject.height.meters, 10)
    XCTAssertEqual(subject.asWarmBlooded?.height.meters, 10)
    XCTAssertEqual(subject.asWarmBlooded?.height.yards, 3)
  }

}
