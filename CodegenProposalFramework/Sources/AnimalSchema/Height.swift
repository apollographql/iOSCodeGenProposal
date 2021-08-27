import CodegenProposalFramework

public final class Height: CacheEntity {
  override public class var __typename: String { "Height" }

  @CacheField("relativeSize") var relativeSize: GraphQLEnum<RelativeSize>?
  @CacheField("centimeters") var centimeters: Int?
  @CacheField("meters") var meters: Int?
  @CacheField("feet") var feet: Int?
  @CacheField("inches") var inches: Int?
  @CacheField("yards") var yards: Int?
}
