@testable import CodegenProposalFramework

public protocol SelectionSet: CodegenProposalFramework.SelectionSet where Schema == TypesUsed{

}


public struct TypesUsed: SchemaTypeFactory {
  public static func entityType(forTypename __typename: String) -> CacheEntity.Type? {
    switch __typename {
    case "Bird": return Bird.self
    case "Cat": return Cat.self
    case "Crocodile": return Crocodile.self
    case "Dog": return Dog.self
    case "Fish": return Fish.self
    case "Height": return Height.self
    case "Human": return Human.self
    case "PetRock": return PetRock.self
    case "Query": return RootQuery.self // TODO, should this be named Query or RootQuery? -- What's the __typename returned for that object?
    case "Rat": return Rat.self
    default: return nil
    }
  }

  public enum Union: String, SchemaUnion { // TODO: Delete this and replace with better option.
    case ClassroomPet

    public var possibleTypes: [CacheEntity.Type] {
      switch self {
      case .ClassroomPet:
        return [Cat.self, Bird.self, Rat.self, PetRock.self]
      }
    }
  }
}
