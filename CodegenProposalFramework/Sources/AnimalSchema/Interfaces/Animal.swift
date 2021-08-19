import CodegenProposalFramework

public final class Animal: CacheInterface {
  @CacheField("species") var species: String?
  @CacheField("height") var height: Height?
//  @CacheField("predators") var predators: [Animal]
  @CacheField("skinCovering") var skinCovering: GraphQLEnum<SkinCovering>?
}
