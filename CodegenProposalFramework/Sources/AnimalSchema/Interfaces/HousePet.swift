import CodegenProposalFramework

public final class HousePet: Interface {
  @CacheField("species") var species: String?
  @CacheField("height") var height: Height?
//  @CacheField("predators") var predators: [HousePet]
  @CacheField("skinCovering") var skinCovering: GraphQLEnum<SkinCovering>?
  @CacheField("humanName") var humanName: String?
  @CacheField("favoriteToy") var favoriteToy: String?
  @CacheField("owner") var owner: Human?
  @CacheField("bodyTemperature") var bodyTemperature: Int?
  @CacheField("laysEggs") var laysEggs: Bool?
  @CacheField("bestFriend") var bestFriend: Pet?
  @CacheField("rival") var rival: Pet?
  @CacheField("livesWith") var livesWith: Union<ClassroomPet>?
}
