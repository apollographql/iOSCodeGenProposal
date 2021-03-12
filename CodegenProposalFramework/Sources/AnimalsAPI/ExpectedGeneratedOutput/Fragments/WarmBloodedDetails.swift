@testable import CodegenProposalFramework

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
  static var __parentType: SelectionSetType<AnimalSchema> { .Interface(.WarmBlooded) }

  let data: ResponseDict

  var bodyTemperature: Int { data["bodyTemperature"] }
  var height: Height  { data["height"] }

  struct Height: SelectionSet {
    static var __parentType: SelectionSetType<AnimalSchema> { .ObjectType(.Height) }
    let data: ResponseDict

    var meters: Int { data["meters"] }
    var yards: Int { data["yards"] }
  }  
}
