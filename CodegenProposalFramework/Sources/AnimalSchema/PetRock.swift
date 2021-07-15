import CodegenProposalFramework

public final class PetRock: Pet, CacheEntity {
  @CacheField var humanName: String?
  @CacheField var favoriteToy: String?
  @CacheField var owner: Human?  
}
