import CodegenProposalFramework

public final class Dog: CacheEntity {
  override public class var __typename: String { "Dog" }

  @CacheField("species") var species: String?
  @CacheField("height") var height: Height?
  @CacheList var predators: [Animal]
  @CacheField("skinCovering") var skinCovering: GraphQLEnum<SkinCovering>?
  @CacheField("humanName") var humanName: String?
  @CacheField("favoriteToy") var favoriteToy: String?
  @CacheField("owner") var owner: Human?
  @CacheField("bodyTemperature") var bodyTemperature: Int?
  @CacheField("laysEggs") var laysEggs: Bool?
  @CacheField("bestFriend") var bestFriend: HousePet?
  @CacheField("rival") var rival: Cat?
  @CacheField("livesWith") var livesWith: Bird?

  // MARK: - Metadata
  override public class var __metadata: Metadata { _metadata }
  private static let _metadata: Metadata = Metadata(
    implements: [Animal.self, Pet.self, WarmBlooded.self, HousePet.self],
    covariantFields: ["bestFriend": HousePet.self, "rival": Cat.self, "livesWith": Bird.self]
  )
}
