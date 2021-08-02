import CodegenProposalFramework

public final class Cat: CacheEntity, Animal, Pet, WarmBlooded {
  @CacheList var predators: [Animal]
  @CacheField("species") var species: String?
  @CacheField("height") var height: Height?
  @CacheField("skinCovering") var skinCovering: GraphQLEnum<SkinCovering>?
  @CacheField("humanName") var humanName: String?
  @CacheField("favoriteToy") var favoriteToy: String?
  @CacheField("owner") var owner: Human?
  @CacheField("bodyTemperature") var bodyTemperature: Int?
  @CacheField("laysEggs") var laysEggs: Bool?
  @CacheField("isJellicle") var isJellicle: Bool?
}
