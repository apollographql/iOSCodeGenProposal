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
final class WarmBloodedDetails:
  ResponseObjectBase<WarmBloodedDetails.Fields, Void>,  Fragment {
  final class Fields {
    let bodyTemperature: Int
    let height: Height

    init(bodyTemperature: Int, height: Height) {
      self.bodyTemperature = bodyTemperature
      self.height = height
    }
  }

  final class Height: ResponseObjectBase<Height.Fields, Void> {
    final class Fields {
      let meters: Int
      let yards: Int

      init(meters: Int, yards: Int) {
        self.meters = meters
        self.yards = yards
      }
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
class AsWarmBloodedDetails<Parent: ResponseObject>:
  FragmentTypeConditionBase<WarmBloodedDetails, Parent> {
  final class Fragments: ToFragments<Parent, ResponseData> {
    private(set) lazy var warmBloodedDetails = WarmBloodedDetails(data: self.data)
  }
}
