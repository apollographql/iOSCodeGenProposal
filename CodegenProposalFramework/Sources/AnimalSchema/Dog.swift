import CodegenProposalFramework

public final class Dog: CacheEntity {
  @CacheField("species") var species: String?
  @CacheField("height") var height: Height?
  @CacheList var predators: [Animal]
  @CacheField("skinCovering") var skinCovering: GraphQLEnum<SkinCovering>?
  @CacheField("humanName") var humanName: String?
  @CacheField("favoriteToy") var favoriteToy: String?
  @CacheField("owner") var owner: Human?
  @CacheField("bodyTemperature") var bodyTemperature: Int?
  @CacheField("laysEggs") var laysEggs: Bool?
  @CacheField("bestFriend") var bestFriend: HousePet?
  @CacheField("rival") var rival: Cat?

  override public class var __metadata: Metadata { _metadata }
  private static let _metadata: Metadata = Metadata(
    implements: [Animal.self, Pet.self, WarmBlooded.self, HousePet.self],
    typeForField: { switch $0 {
    case "species", "humanName", "favoriteToy": return String.self
    case "height": return Height.self
    case "bodyTemperature": return Int.self
    case "laysEggs": return Bool.self
    case "bestFriend": return HousePet.self
    case "rival": return Cat.self
    default: return nil
    } }
  )
}
