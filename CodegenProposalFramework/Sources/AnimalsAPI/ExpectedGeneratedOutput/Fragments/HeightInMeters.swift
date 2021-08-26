@testable import CodegenProposalFramework
import AnimalSchema

/// A response data object for a `HeightInMeters` fragment
///
/// ```
/// fragment HeightInMeters on Animal {
///   height {
///     meters
///   }
/// }
/// ```
struct HeightInMeters: SelectionSet, Fragment {
  static var __parentType: AnimalSchema.ParentType { .Interface(AnimalSchema.Animal.self) }
  let data: ResponseDict

  var height: Height  { data["height"] }

  struct Height: SelectionSet {
    static var __parentType: AnimalSchema.ParentType { .ObjectType(AnimalSchema.Height.self) }
    let data: ResponseDict

    var meters: Int { data["meters"] }
  }
}
