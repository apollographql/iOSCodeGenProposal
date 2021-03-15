@testable import CodegenProposalFramework

struct AnimalSchema: GraphQLSchema {
  enum ObjectType: String, SchemaObjectType {
    case Bird, Cat, Coyote, Crocodile, Fish, Height, PetRock, Query, Rat, _unknown

    static let unknownCase: ObjectType = ._unknown

    var interfaces: [Interface] {
      switch self {
      case .Bird, .Cat, .Rat:
        return [.Animal, .Pet, .WarmBlooded]
      case .Coyote:
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

    func implements(_ interface: Interface) -> Bool {
      interfaces.contains(interface)
    }
  }

  enum Interface: String, SchemaTypeEnum {
    case Animal, Pet, WarmBlooded
  }

  enum Union: String, SchemaTypeEnum {
    case ClassroomPet
  }
}