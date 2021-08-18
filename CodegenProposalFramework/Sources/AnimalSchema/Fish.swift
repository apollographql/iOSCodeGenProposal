import CodegenProposalFramework

public final class Fish: CacheEntity {
  // Animal, Pet
  @CacheList var predators: [CacheReference<Animal>]
  @CacheField("species") var species: String?
  @CacheField("height") var height: CacheReference<Height>?
  @CacheField("skinCovering") var skinCovering: GraphQLEnum<SkinCovering>?
  @CacheField("humanName") var humanName: String?
  @CacheField("favoriteToy") var favoriteToy: String?
  @CacheField("owner") var owner: CacheReference<Human>?
}
