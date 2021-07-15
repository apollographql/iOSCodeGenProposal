import CodegenProposalFramework

public final class Human: Animal, WarmBlooded, CacheEntity {
  @CacheField var firstName: String?
  @CacheField var species: String?
  @CacheField var height: Height?
  @CacheList var predators: [Animal]
  @CacheField var skinCovering: GraphQLEnum<SkinCovering>?
  @CacheField var bodyTemperature: Int?
  @CacheField var laysEggs: Bool?
}
