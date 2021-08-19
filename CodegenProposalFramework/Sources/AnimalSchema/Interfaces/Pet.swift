import CodegenProposalFramework

public final class Pet: CacheInterface {
  @CacheField("humanName") var humanName: String?
  @CacheField("favoriteToy") var favoriteToy: String?
  @CacheField("owner") var owner: Human?
}
