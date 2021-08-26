import CodegenProposalFramework

public final class Cat: CacheEntity {
  @CacheList var predators: [Animal]
  @CacheField("species") var species: String?
  @CacheField("height") var height: Height?
  @CacheField("skinCovering") var skinCovering: GraphQLEnum<SkinCovering>?
  @CacheField("humanName") var humanName: String?
  @CacheField("favoriteToy") var favoriteToy: String?
  @CacheField("owner") var owner: Human?
  @CacheField("bodyTemperature") var bodyTemperature: Int?
  @CacheField("laysEggs") var laysEggs: Bool?
  @CacheField("isJellicle") var isJellicle: Bool?

  override public class var __metadata: Metadata { _metadata }
  private static let _metadata: Metadata = Metadata(
    implements: [Animal.self, Pet.self, WarmBlooded.self],
    typeForField: { switch $0 {
    case "species", "humanName", "favoriteToy": return String.self
    case "bodyTemperature", "wingspan": return Int.self
    case "laysEggs", "isJellicle": return Bool.self
    case "skinCovering": return GraphQLEnum<SkinCovering>.self
//    case "predators": return [Animal].self
    case "height": return Height.self
    case "owner": return Human.self
    default: return nil
    } }
  )
}
