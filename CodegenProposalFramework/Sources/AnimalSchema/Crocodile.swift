import CodegenProposalFramework

public final class Crocodile: CacheEntity {
  public static let __typename: String = "Crocodile"

  @CacheField("species") var species: String?
  @CacheField("height") var height: Height?
  @CacheField("skinCovering") var skinCovering: GraphQLEnum<SkinCovering>?
  @CacheField("age") var age: Int?
  @CacheList var predators: [Animal]

  override public class var __metadata: Metadata { _metadata }
  private static let _metadata: Metadata = Metadata(
    implements: [Animal.self]
  )
}
