import CodegenProposalFramework

public final class Crocodile: CacheEntity {
  // Animal
  @CacheField("species") var species: String?
  @CacheField("height") var height: CacheReference<Height>?
  @CacheField("skinCovering") var skinCovering: GraphQLEnum<SkinCovering>?
  @CacheField("age") var age: Int?
  @CacheList var predators: [CacheReference<Animal>]
}
