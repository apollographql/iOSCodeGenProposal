@testable import CodegenProposalFramework
import AnimalSchema

struct ClassroomPetsWithSubtypesQuery {
  let data: ResponseData

  struct ResponseData: SelectionSet {
    static var __parentType: AnimalSchema.ParentType { .ObjectType(AnimalSchema.RootQuery.self) }
    let data: ResponseDict

    var classroomPets: [ClassroomPet] { data["classroomPets"] }

    struct ClassroomPet: SelectionSet {
      static var __parentType: AnimalSchema.ParentType { .Union(.ClassroomPet) }
      let data: ResponseDict

      var asAnimal: AsAnimal? { _asType() }
      var asPet: AsPet? { _asType() }
      var asWarmBlooded: AsWarmBlooded? { _asType() }

      var asCat: AsCat? { _asType() }
      var asBird: AsBird? { _asType() }
      var asPetRock: AsPetRock? { _asType() }
      var asRat: AsRat? { _asType() }

      var subtype: SubType { SubType(data: data) }

      enum SubType {
        case bird(AsBird)
        case cat(AsCat)
        case rat(AsRat)
        case petRock(AsPetRock)
        case other(ResponseDict)

        init(data: ResponseDict) {
          switch Schema.ObjectType(rawValue: data["__typename"]) {
          case .Bird: self = .bird(AsBird(data: data))
          case .Cat: self = .cat(AsCat(data: data))
          case .Rat: self = .rat(AsRat(data: data))
          case .PetRock: self = .petRock(AsPetRock(data: data))
          default: self = .other(data)
          }
        }
      }

      /// `ClassroomPet.AsAnimal`
      struct AsAnimal: SelectionSet {
        static var __parentType: AnimalSchema.ParentType { .Interface(AnimalSchema.Animal.self) }
        let data: ResponseDict

        var species: String { data["species"] }
      }

      /// `ClassroomPet.AsPet`
      struct AsPet: SelectionSet {
        static var __parentType: AnimalSchema.ParentType { .Interface(AnimalSchema.Pet.self) }
        let data: ResponseDict

        var species: String { data["species"] }
        var humanName: String? { data["humanName"] }
      }

      /// `ClassroomPet.AsWarmBlooded`
      struct AsWarmBlooded: SelectionSet {
        static var __parentType: AnimalSchema.ParentType { .Interface(AnimalSchema.Animal.self) }
        let data: ResponseDict

        var species: String { data["species"] }
        var laysEggs: Bool { data["laysEggs"] }
      }

      /// `ClassroomPet.AsCat`
      struct AsCat: SelectionSet {
        static var __parentType: AnimalSchema.ParentType { .ObjectType(AnimalSchema.Cat.self) }
        let data: ResponseDict

        var species: String { data["species"] }
        var humanName: String? { data["humanName"] }
        var laysEggs: Bool { data["laysEggs"] }
        var bodyTemperature: Int { data["bodyTemperature"] }
        var isJellicle: Bool { data["isJellicle"] }
      }


      /// `ClassroomPet.AsBird`
      struct AsBird: SelectionSet {
        static var __parentType: AnimalSchema.ParentType { .ObjectType(AnimalSchema.Bird.self) }
        let data: ResponseDict

        var species: String { data["species"] }
        var humanName: String? { data["humanName"] }
        var laysEggs: Bool { data["laysEggs"] }
        var wingspan: Int { data["wingspan"] }
      }

      /// `ClassroomPet.AsRat`
      struct AsRat: SelectionSet {
        static var __parentType: AnimalSchema.ParentType { .ObjectType(AnimalSchema.Rat.self) }
        let data: ResponseDict

        var species: String { data["species"] }
        var humanName: String? { data["humanName"] }
        var laysEggs: Bool { data["laysEggs"] }
      }

      /// `ClassroomPet.AsPetRock`
      struct AsPetRock: SelectionSet {
        static var __parentType: AnimalSchema.ParentType { .ObjectType(AnimalSchema.PetRock.self) }
        let data: ResponseDict

        var humanName: String? { data["humanName"] }
        var favoriteToy: String { data["favoriteToy"] }
      }
    }
  }
}
