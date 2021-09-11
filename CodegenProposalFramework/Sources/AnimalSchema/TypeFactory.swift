@testable import CodegenProposalFramework

public protocol SelectionSet: CodegenProposalFramework.SelectionSet & RootSelectionSet
where Schema == AnimalSchemaTypeFactory {}

public protocol TypeCase: CodegenProposalFramework.TypeCase
where Schema == AnimalSchemaTypeFactory {}

public enum AnimalSchemaTypeFactory: SchemaTypeFactory {
  public static func objectType(forTypename __typename: String) -> Object.Type? {
    switch __typename {
    case "Bird": return Bird.self
    case "Cat": return Cat.self
    case "Crocodile": return Crocodile.self
    case "Dog": return Dog.self
    case "Fish": return Fish.self
    case "Height": return Height.self
    case "Human": return Human.self
    case "PetRock": return PetRock.self
    case "Query": return Query.self
    case "Rat": return Rat.self
    default: return nil
    }
  }
}
