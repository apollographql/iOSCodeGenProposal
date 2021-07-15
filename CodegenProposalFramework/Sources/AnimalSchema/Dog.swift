import CodegenProposalFramework

public final class Dog: Animal, Pet, HousePet, WarmBlooded, CacheEntity {
  @CacheField var species: String?
  @CacheField var height: Height?
  @CacheList var predators: [HousePet]
  @CacheField var skinCovering: GraphQLEnum<SkinCovering>?
  @CacheField var humanName: String?
  @CacheField var favoriteToy: String?
  @CacheField var owner: Human?
  @CacheField var bodyTemperature: Int?
  @CacheField var laysEggs: Bool?
  @CacheField var isJellicle: Bool?
}

extension Animal where Self == Dog {
  var predators: [Animal] { self.$predators.wrappedValue }
}
