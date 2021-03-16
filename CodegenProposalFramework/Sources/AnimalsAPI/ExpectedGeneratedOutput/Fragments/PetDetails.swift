@testable import CodegenProposalFramework

/// A response data object for a `PetDetails` fragment
///
/// ```
/// fragment PetDetails on Pet {
///  humanName
///  favoriteToy
///  owner {
///    firstName
///  }
/// }
/// ```
struct PetDetails: SelectionSet, Fragment {
  static var __parentType: SelectionSetType<AnimalSchema> { .Interface(.Pet) }
  let data: ResponseDict

  var humanName: String? { data["humanName"] }
  var favoriteToy: String { data["favoriteToy"] }
  var owner: Human? { data["owner"] }

  struct Human: SelectionSet {
    static var __parentType: SelectionSetType<AnimalSchema> { .ObjectType(.Human) }
    let data: ResponseDict

    var firstName: String { data["firstName"] }
  }
}
