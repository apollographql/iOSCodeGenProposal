@testable import CodegenProposalFramework

let cat = AllAnimals(__typename: "Cat",
                     species: "Cat",
                     height: .init(props: .init(__typename: "Height", feet: 2, inches: 10, meters: 4)))
//  .makeAsPet(humanName: "Tiger Lily", favoriteToy: "Shoelaces")
//  .makeAsWarmBlooded(bodyTemperature: 100)

//let species = cat.species // This code completes all properties and accesses them properly!

cat.height
