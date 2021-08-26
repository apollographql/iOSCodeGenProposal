@testable import CodegenProposalFramework
import AnimalSchema

/// A response data object for a `WarmBloodedDetails` fragment
///
/// ```
/// fragment WarmBloodedDetails on WarmBlooded {
///   bodyTemperature
///   height {
///     meters // TODO: Use HeightInMeters fragment?
///     yards
///   }
/// }
/// ```
struct WarmBloodedDetails: SelectionSet, Fragment {
  static var __parentType: AnimalSchema.ParentType { .Interface(AnimalSchema.WarmBlooded.self) }

  let data: ResponseDict

  var bodyTemperature: Int { data["bodyTemperature"] }
  var height: Height  { data["height"] }

  struct Height: SelectionSet {
    static var __parentType: AnimalSchema.ParentType { .ObjectType(AnimalSchema.Height.self) }
    let data: ResponseDict

    var meters: Int { data["meters"] }
    var yards: Int { data["yards"] }
  }  
}
