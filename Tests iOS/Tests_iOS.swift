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

  func testExample() throws {
    let cat = AllAnimals(__typename: "Cat",
                         species: "Cat",
                         height: .init(props: .init(__typename: "Height", feet: 2, inches: 10, meters: 4)))

    XCTAssertEqual(cat.species, "Cat")
  }

}
