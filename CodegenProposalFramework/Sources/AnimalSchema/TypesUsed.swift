@testable import CodegenProposalFramework

public typealias ParentType = SelectionSetType<TypesUsed>

public struct TypesUsed: SchemaTypeMetadata {

  public enum ObjectType: String, SchemaObjectType {
    case Bird, Cat, Crocodile, Dog, Fish, Height, Human, PetRock, Query, Rat, _unknown

    public static let unknownCase: ObjectType = ._unknown

    public var implementedInterfaces: Set<Interface> {
      switch self {
      case .Dog:
        return [.Animal, .HousePet, .Pet, .WarmBlooded]
      case .Bird, .Cat, .Rat:
        return [.Animal, .Pet, .WarmBlooded]
      case .Human:
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

    public var entityType: CacheEntity.Type? {
      switch self {
      case .Bird: return AnimalSchema.Bird.self
      case .Cat: return AnimalSchema.Cat.self
      case .Crocodile: return AnimalSchema.Crocodile.self
      case .Dog: return AnimalSchema.Dog.self
      case .Fish: return AnimalSchema.Fish.self
      case .Height: return AnimalSchema.Height.self
      case .Human: return AnimalSchema.Human.self
      case .PetRock: return AnimalSchema.PetRock.self
      case .Query: return AnimalSchema.RootQuery.self // TODO, should this be named Query or RootQuery? -- What's the __typename returned for that object?
      case .Rat: return AnimalSchema.Rat.self
      case ._unknown: return nil
      }
    }
  }

  public enum Interface: String, SchemaTypeEnum {
    case Animal, HousePet, Pet, WarmBlooded
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
