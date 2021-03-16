@testable import CodegenProposalFramework

struct AnimalSchema: GraphQLSchema {
  enum ObjectType: String, SchemaObjectType {
    case Bird, Cat, Coyote, Crocodile, Fish, Height, Human, PetRock, Query, Rat, _unknown

    static let unknownCase: ObjectType = ._unknown

    var implementedInterfaces: [Interface] {
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

  enum Interface: String, SchemaTypeEnum {
    case Animal, Pet, WarmBlooded
  }

  enum Union: String, SchemaUnion {
    case ClassroomPet

    var possibleTypes: [ObjectType] {
      switch self {
      case .ClassroomPet:
        return [.Cat, .Bird, .Rat, .PetRock]
      }
    }
  }
}
