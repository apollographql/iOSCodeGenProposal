@testable import CodegenProposalFramework
import AnimalSchema

/// A response data object for a `ClassroomPetDetails` fragment
struct ClassroomPetDetails: SelectionSet, Fragment {
  static var __parentType: SelectionSetType<AnimalSchema> { .Union(.ClassroomPet) }
  let data: ResponseDict

  var asAnimal: AsAnimal? { _asType() }
  var asPet: AsPet? { _asType() }
  var asWarmBlooded: AsWarmBlooded? { _asType() }

  var asCat: AsCat? { _asType() }
  var asBird: AsBird? { _asType() }
  var asPetRock: AsPetRock? { _asType() }

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
    var humanName: String? { data["humanName"] }
  }

  /// `ClassroomPet.AsWarmBlooded`
  struct AsWarmBlooded: SelectionSet {
    static var __parentType: SelectionSetType<AnimalSchema> { .Interface(.Animal) }
    let data: ResponseDict

    var species: String { data["species"] }
    var laysEggs: Bool { data["laysEggs"] }
  }

  /// `ClassroomPet.AsCat`
  struct AsCat: SelectionSet {
    static var __parentType: SelectionSetType<AnimalSchema> { .ObjectType(.Cat) }
    let data: ResponseDict

    var species: String { data["species"] }
    var humanName: String? { data["humanName"] }
    var laysEggs: Bool { data["laysEggs"] }
    var bodyTemperature: Int { data["bodyTemperature"] }
    var isJellicle: Bool { data["isJellicle"] }
  }

  /// `ClassroomPet.AsBird`
  struct AsBird: SelectionSet {
    static var __parentType: SelectionSetType<AnimalSchema> { .ObjectType(.Bird) }
    let data: ResponseDict

    var species: String { data["species"] }
    var humanName: String? { data["humanName"] }
    var laysEggs: Bool { data["laysEggs"] }
    var wingspan: Int { data["wingspan"] }
  }

  /// `ClassroomPet.AsPetRock`
  struct AsPetRock: SelectionSet {
    static var __parentType: SelectionSetType<AnimalSchema> { .ObjectType(.PetRock) }
    let data: ResponseDict

    var humanName: String? { data["humanName"] }
    var favoriteToy: String { data["favoriteToy"] }
  }
}
