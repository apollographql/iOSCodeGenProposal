import CodegenProposalFramework

public final class PetRock: CacheEntity {
  override public class var __typename: String { "PetRock" }
  
  @CacheField("humanName") var humanName: String?
  @CacheField("favoriteToy") var favoriteToy: String?
  @CacheField("owner") var owner: Human?

  override public class var __metadata: Metadata { _metadata }
  private static let _metadata: Metadata = Metadata(
    implements: [Pet.self]
  )
}
