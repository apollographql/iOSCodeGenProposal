import CodegenProposalFramework

public final class PetRock: CacheEntity {
  // Pet
  @CacheField("humanName") var humanName: String?
  @CacheField("favoriteToy") var favoriteToy: String?
  @CacheField("owner") var owner: Human?
}
