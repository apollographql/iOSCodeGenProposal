@testable import CodegenProposalFramework

struct ClassroomPetsQuery {
  let data: ResponseData

  struct ResponseData: SelectionSet {
    static var __parentType: SelectionSetType<AnimalSchema> { .ObjectType(.Query) }
    let data: ResponseDict

    var classroomPets: [ClassroomPet] { data["classroomPets"] }

    struct ClassroomPet: SelectionSet {
      static var __parentType: SelectionSetType<AnimalSchema> { .Union(.ClassroomPet) }
      let data: ResponseDict

      var asAnimal: AsAnimal? { _asType() }
      var asPet: AsPet? { _asType() }
      var asWarmBlooded: AsWarmBlooded? { _asType() }

      var asCat: Cat? { _asType() }
      var asBird: Bird? { _asType() }
      var asPetRock: PetRock? { _asType() }

      /// `ClassroomPet.AsAnimal`
      struct AsAnimal: SelectionSet {
        static var __parentType: SelectionSetType<AnimalSchema> { .Interface(.Animal) }
        let data: ResponseDict

        var species: String { data["species"] }
      }

      /// `ClassroomPet.AsPet`
      struct AsPet: SelectionSet {
        static var __parentType: SelectionSetType<AnimalSchema> { .Interface(.Pet) }
        let data: ResponseDict

        var species: String { data["species"] }
        var humanName: String { data["humanName"] }
      }

      /// `ClassroomPet.AsWarmBlooded`
      struct AsWarmBlooded: SelectionSet {
        static var __parentType: SelectionSetType<AnimalSchema> { .Interface(.Animal) }
        let data: ResponseDict

        var species: String { data["species"] }
        var hasFur: Bool { data["hasFur"] }
      }

      /// `ClassroomPet.Cat`
      struct Cat: SelectionSet {
        static var __parentType: SelectionSetType<AnimalSchema> { .ObjectType(.Cat) }
        let data: ResponseDict

        var species: String { data["species"] }
        var humanName: String { data["humanName"] }
        var hasFur: Bool { data["hasFur"] }
        var bodyTemperature: Int { data["bodyTemperature"] }
        var isJellicle: Bool { data["isJellicle"] }
      }


      /// `ClassroomPet.Bird`
      struct Bird: SelectionSet {
        static var __parentType: SelectionSetType<AnimalSchema> { .ObjectType(.Bird) }
        let data: ResponseDict

        var species: String { data["species"] }
        var humanName: String { data["humanName"] }
        var hasFur: Bool { data["hasFur"] }
        var wingspan: Int { data["wingspan"] }
      }

      /// `ClassroomPet.PetRock`
      struct PetRock: SelectionSet {
        static var __parentType: SelectionSetType<AnimalSchema> { .ObjectType(.PetRock) }
        let data: ResponseDict

        var humanName: String { data["humanName"] }
        var favoriteToy: String { data["favoriteToy"] }
      }
    }
  }
}
