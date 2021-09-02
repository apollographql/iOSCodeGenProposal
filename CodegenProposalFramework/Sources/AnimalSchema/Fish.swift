import CodegenProposalFramework

public final class Fish: Object {
  override public class var __typename: String { "Fish" }

  @CacheList var predators: [Animal]
  @CacheField("species") var species: String?
  @CacheField("height") var height: Height?
  @CacheField("skinCovering") var skinCovering: GraphQLEnum<SkinCovering>?
  @CacheField("humanName") var humanName: String?
  @CacheField("favoriteToy") var favoriteToy: String?
  @CacheField("owner") var owner: Human?

  override public class var __metadata: Metadata { _metadata }
  private static let _metadata: Metadata = Metadata(
    implements: [Animal.self, Pet.self]
  )
}
