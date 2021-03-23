@testable import CodegenProposalFramework

/// A response data object for a `HeightInMeters` fragment
///
/// ```
/// fragment HeightInMeters on Animal {
///   height {
///     meters
///   }
/// }
/// ```
struct HeightInMeters: SelectionSet {
  static var __parentType: SelectionSetType<AnimalSchema> { .Interface(.Animal) }
  let data: ResponseDict

  var height: Height  { data["height"] }

  struct Height: SelectionSet {
    static var __parentType: SelectionSetType<AnimalSchema> { .ObjectType(.Height) }
    let data: ResponseDict

    var meters: Int { data["meters"] }
  }
}
