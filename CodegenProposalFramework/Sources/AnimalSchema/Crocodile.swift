import CodegenProposalFramework

public final class Crocodile: CacheEntity {
  @CacheField("species") var species: String?
  @CacheField("height") var height: Height?
  @CacheField("skinCovering") var skinCovering: GraphQLEnum<SkinCovering>?
  @CacheField("age") var age: Int?
  @CacheList var predators: [Animal]

  override public class var __metadata: Metadata { _metadata }
  private static let _metadata: Metadata = Metadata(
    implements: [Animal.self],
    typeForField: { switch $0 {
    case "species": return String.self
    case "age": return Int.self
    case "skinCovering": return GraphQLEnum<SkinCovering>.self
//    case "predators": return [Animal].self
    case "height": return Height.self
    default: return nil
    } }
  )
}
