import CodegenProposalFramework

public final class Human: CacheEntity, Animal, WarmBlooded {
  @CacheList var predators: [Animal]
  @CacheField("firstName") var firstName: String?
  @CacheField("species") var species: String?
  @CacheField("height") var height: Height?
  @CacheField("skinCovering") var skinCovering: GraphQLEnum<SkinCovering>?
  @CacheField("bodyTemperature") var bodyTemperature: Int?
  @CacheField("laysEggs") var laysEggs: Bool?
}
