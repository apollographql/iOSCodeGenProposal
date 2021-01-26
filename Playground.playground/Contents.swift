@testable import CodegenProposalFramework

let cat = AllAnimals(__typename: "Cat", species: "Cat")
  .makeAsPet(humanName: "Tiger Lily", favoriteToy: "Shoelaces")
  .makeAsWarmBlooded(bodyTemperature: 100)

let species = cat.species // This code completes all properties and accesses them properly!
