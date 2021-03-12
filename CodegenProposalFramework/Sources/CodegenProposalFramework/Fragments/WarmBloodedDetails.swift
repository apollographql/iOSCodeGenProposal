//
//  WarmBloodedDetails.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/16/21.
//

import Foundation

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

  let data: ResponseData

  var bodyTemperature: Int { data["bodyTemperature"] }
  var height: Height  { data["height"] }

  struct Height: SelectionSet {
    static var __parentType: SelectionSetType<AnimalSchema> { .ObjectType(.Height) }
    let data: ResponseData

    var meters: Int { data["meters"] }
    var yards: Int { data["yards"] }
  }  
}
