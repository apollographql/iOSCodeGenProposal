@testable import CodegenProposalFramework

let cat = Animal(__typename: "Cat",
                 species: "Cat",
                 height: .init(props: .init(__typename: "Height", feet: 2, inches: 10, meters: 4)))
  .makeAsWarmBlooded(bodyTemperature: 98, height: .init(props: .init(meters: 10))).parent
  .makeAsPet(humanName: "Tiger Lily", favoriteToy: "Shoelaces")
//  .makeAsWarmBlooded(bodyTemperature: 100)

//let species = cat.species // This code completes all properties and accesses them properly!

let height = cat.height
cat.favoriteToy

cat.parent.asWarmBlooded?.height.meters
(cat.parent.asWarmBlooded?.height as WarmBloodedDetails.Height?)?.meters
