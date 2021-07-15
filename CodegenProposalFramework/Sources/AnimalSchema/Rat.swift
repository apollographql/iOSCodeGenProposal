import CodegenProposalFramework

public final class Rat: Animal, Pet, CacheEntity {
  @CacheField var species: String?
  @CacheField var height: Height?
  @CacheList var predators: [Animal]
  @CacheField var skinCovering: GraphQLEnum<SkinCovering>?
  @CacheField var humanName: String?
  @CacheField var favoriteToy: String?
  @CacheField var owner: Human?
}
