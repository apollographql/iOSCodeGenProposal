import CodegenProposalFramework

public final class HousePet: CacheInterface {
  @CacheField("species") var species: String?
  @CacheField("height") var height: CacheReference<Height>?
//  @CacheField("predators") var predators: [CacheReference<HousePet>]
  @CacheField("skinCovering") var skinCovering: GraphQLEnum<SkinCovering>?
  @CacheField("humanName") var humanName: String?
  @CacheField("favoriteToy") var favoriteToy: String?
  @CacheField("owner") var owner: CacheReference<Human>?
  @CacheField("bodyTemperature") var bodyTemperature: Int?
  @CacheField("laysEggs") var laysEggs: Bool?
  @CacheField("bestFriend") var bestFriend: CacheReference<Pet>?
}
