import CodegenProposalFramework

protocol WarmBlooded: Animal {
  var species: String? { get }
    var height: Height? { get }
    var predators: [Animal] { get }
    var skinCovering: GraphQLEnum<SkinCovering>? { get }
    var bodyTemperature: Int? { get }
    var laysEggs: Bool? { get }
}
