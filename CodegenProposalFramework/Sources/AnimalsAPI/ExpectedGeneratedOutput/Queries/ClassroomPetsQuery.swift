@testable import CodegenProposalFramework

struct ClassroomPetsQuery {
  let data: ResponseData

  struct ResponseData: SelectionSet {
    static var __parentType: SelectionSetType<AnimalSchema> { .ObjectType(.Query) }
    let data: ResponseDict

    var classroomPets: [ClassroomPetDetails] { data["classroomPets"] }    
  }
}
