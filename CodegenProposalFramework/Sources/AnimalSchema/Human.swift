import CodegenProposalFramework

public final class Human: CacheEntity {
  // Animal, WarmBlooded
  @CacheList var predators: [CacheReference<Animal>]
  @CacheField("firstName") var firstName: String?
  @CacheField("species") var species: String?
  @CacheField("height") var height: CacheReference<Height>?
  @CacheField("skinCovering") var skinCovering: GraphQLEnum<SkinCovering>?
  @CacheField("bodyTemperature") var bodyTemperature: Int?
  @CacheField("laysEggs") var laysEggs: Bool?
}
