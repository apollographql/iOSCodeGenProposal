import CodegenProposalFramework

public final class Dog: CacheEntity {
  @CacheField("species") var species: String?
  @CacheField("height") var height: Height?
  @CacheList var predators: [HousePet]
  @CacheField("skinCovering") var skinCovering: GraphQLEnum<SkinCovering>?
  @CacheField("humanName") var humanName: String?
  @CacheField("favoriteToy") var favoriteToy: String?
  @CacheField("owner") var owner: Human?
  @CacheField("bodyTemperature") var bodyTemperature: Int?
  @CacheField("laysEggs") var laysEggs: Bool?
  @CacheField("isJellicle") var isJellicle: Bool?
  @CacheField("bestFriend") var bestFriend: HousePet?

  override public class var __metadata: Metadata { _metadata }
  private static let _metadata: Metadata = Metadata(
    interfaces: [Animal.self, Pet.self, WarmBlooded.self, HousePet.self],
    typeForField: { switch $0 {
    case "species", "humanName", "favoriteToy": return String.self
    case "height": return Height.self
    case "bodyTemperature": return Int.self
    case "laysEggs", "isJellicle": return Bool.self
    case "bestFriend": return HousePet.self
    default: return nil
    } }
  )
}
