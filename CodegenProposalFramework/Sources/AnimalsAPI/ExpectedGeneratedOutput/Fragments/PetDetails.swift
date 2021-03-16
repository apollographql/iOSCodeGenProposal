@testable import CodegenProposalFramework

/// A response data object for a `PetDetails` fragment
///
/// ```
/// fragment PetDetails on Pet {
///  humanName
///  favoriteToy
/// }
/// ```
struct PetDetails: SelectionSet, Fragment {
  static var __parentType: SelectionSetType<AnimalSchema> { .Interface(.Pet) }
  let data: ResponseDict

  var humanName: String? { data["humanName"] }
  var favoriteToy: String { data["favoriteToy"] }
}
