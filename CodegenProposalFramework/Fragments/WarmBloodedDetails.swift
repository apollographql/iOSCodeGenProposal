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
final class WarmBloodedDetails: ResponseObjectBase<WarmBloodedDetails.Fields>, Fragment {
  final class Fields: FieldData {
    @Field("bodyTemperature") final var bodyTemperature: Int
    @Field("height") final var height: Height
  }

  final class Height: ResponseObjectBase<Height.Fields> {
    final class Fields: FieldData {
      @Field("meters") final var meters: Int
      @Field("yards") final var yards: Int
    }
  }  
}

/// A generic type condition for a `WarmBloodedDetails` fragment.
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
class AsWarmBloodedDetails<Parent: ResponseObject>: FragmentTypeConditionBase<WarmBloodedDetails, Parent> {
  final class Fragments: BaseClass.Fragments {
    @ToFragment var warmBloodedDetails: WarmBloodedDetails
  }
}
