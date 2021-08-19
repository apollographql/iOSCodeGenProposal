import CodegenProposalFramework

public final class WarmBlooded: CacheInterface {
  @CacheField("species") var species: String?
  @CacheField("height") var height: Height?
//  @CacheField("predators") var predators: [Animal]
  @CacheField("skinCovering") var skinCovering: GraphQLEnum<SkinCovering>?
  @CacheField("bodyTemperature") var bodyTemperature: Int?
  @CacheField("laysEggs") var laysEggs: Bool?
}
