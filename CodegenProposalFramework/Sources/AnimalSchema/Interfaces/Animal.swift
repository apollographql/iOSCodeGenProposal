import CodegenProposalFramework

protocol Animal: CacheEntity {
  var species: String? { get }
  var height: Height? { get }
  var predators: [Animal] { get }
  var skinCovering: GraphQLEnum<SkinCovering>? { get }
}
