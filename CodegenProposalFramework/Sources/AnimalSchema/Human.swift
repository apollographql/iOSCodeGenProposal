import CodegenProposalFramework

public final class Human: CacheEntity {
  public static let __typename: String = "Human"
  
  @CacheList var predators: [Animal]
  @CacheField("firstName") var firstName: String?
  @CacheField("species") var species: String?
  @CacheField("height") var height: Height?
  @CacheField("skinCovering") var skinCovering: GraphQLEnum<SkinCovering>?
  @CacheField("bodyTemperature") var bodyTemperature: Int?
  @CacheField("laysEggs") var laysEggs: Bool?

  override public class var __metadata: Metadata { _metadata }
  private static let _metadata: Metadata = Metadata(
    implements: [Animal.self, WarmBlooded.self]
  )
}
