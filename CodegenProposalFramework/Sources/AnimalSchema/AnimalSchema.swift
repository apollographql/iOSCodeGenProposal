@testable import CodegenProposalFramework

public struct AnimalSchema: GraphQLSchema {
  public enum ObjectType: String, SchemaObjectType {
    case Bird, Cat, Coyote, Crocodile, Fish, Height, Human, PetRock, Query, Rat, _unknown

    public static let unknownCase: ObjectType = ._unknown

    public var implementedInterfaces: [Interface] {
      switch self {
      case .Bird, .Cat, .Rat:
        return [.Animal, .Pet, .WarmBlooded]
      case .Coyote, .Human:
        return [.Animal, .WarmBlooded]
      case .Crocodile:
        return [.Animal]
      case .Fish:
        return [.Animal, .Pet]
      case .PetRock:
        return [.Pet]
      default:
        return []
      }
    }
  }

  public enum Interface: String, SchemaTypeEnum {
    case Animal, Pet, WarmBlooded
  }

  public enum Union: String, SchemaUnion {
    case ClassroomPet

    public var possibleTypes: [ObjectType] {
      switch self {
      case .ClassroomPet:
        return [.Cat, .Bird, .Rat, .PetRock]
      }
    }
  }
}
