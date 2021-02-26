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
final class WarmBloodedDetails: FieldData, ResponseObject, Fragment {
  @Field("bodyTemperature") final var bodyTemperature: Int
  @Field("height") final var height: Height

  final class Height: FieldData, ResponseObject {
    @Field("meters") final var meters: Int
    @Field("yards") final var yards: Int
  }  
}
