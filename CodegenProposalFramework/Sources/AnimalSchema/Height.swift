import CodegenProposalFramework

public final class Height: CacheEntity {
  @CacheField var relativeSize: GraphQLEnum<RelativeSize>?
  @CacheField var centimeters: Int?
  @CacheField var meters: Int?
  @CacheField var feet: Int?
  @CacheField var inches: Int?
  @CacheField var yards: Int?
}
