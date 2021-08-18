import CodegenProposalFramework

public final class Animal: CacheInterface {
  @CacheField("species") var species: String?
  @CacheField("height") var height: CacheReference<Height>?
//  @CacheField("predators") var predators: [CacheReference<Animal>]
  @CacheField("skinCovering") var skinCovering: GraphQLEnum<SkinCovering>?
}
