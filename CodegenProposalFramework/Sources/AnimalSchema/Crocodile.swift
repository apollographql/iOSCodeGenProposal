import CodegenProposalFramework

public final class Crocodile: Animal, CacheEntity {
  @CacheField var species: String?
  @CacheField var height: Height?
  @CacheList var predators: [Animal]
  @CacheField var skinCovering: GraphQLEnum<SkinCovering>?
  @CacheField var age: Int?
}
