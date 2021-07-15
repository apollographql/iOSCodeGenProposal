import CodegenProposalFramework

public final class Bird: Animal, Pet, WarmBlooded, CacheEntity {
  @CacheField var species: String?
  @CacheField var height: Height?
  @CacheList var predators: [Animal]
  @CacheField var skinCovering: GraphQLEnum<SkinCovering>?
  @CacheField var humanName: String?
  @CacheField var favoriteToy: String?
  @CacheField var owner: Human?
  @CacheField var bodyTemperature: Int?
  @CacheField var laysEggs: Bool?
  @CacheField var wingspan: Int?
}
