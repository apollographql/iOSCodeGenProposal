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
    }
  }
}
