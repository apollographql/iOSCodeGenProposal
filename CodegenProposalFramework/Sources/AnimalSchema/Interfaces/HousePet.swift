import CodegenProposalFramework

protocol HousePet: Animal {
  var species: String? { get }
  var height: Height? { get }
  var predators: [HousePet] { get }
  var skinCovering: GraphQLEnum<SkinCovering>? { get }
  var humanName: String? { get }
  var favoriteToy: String? { get }
  var owner: Human? { get }
  var bodyTemperature: Int? { get }
  var laysEggs: Bool? { get }
}