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
final class WarmBloodedDetails: Fragment {
  final class Fields {
    let bodyTemperature: Int
    let height: Height

    init(bodyTemperature: Int, height: Height) {
      self.bodyTemperature = bodyTemperature
      self.height = height
    }
  }

  let data: FieldData

  init(data: FieldData) {
    self.data = data
  }

  final class Height: ResponseData {
    final class Fields {
      let meters: Int
      let yards: Int

      init(meters: Int, yards: Int) {
        self.meters = meters
        self.yards = yards
      }
    }

    let data: FieldData

    init(data: FieldData) {
      self.data = data
    }

    subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
      return data.fields[keyPath: keyPath]
    }
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
    return data.fields[keyPath: keyPath]
  }
}

/// A generic type case for a `WarmBloodedDetails` fragment.
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
class AsWarmBloodedDetails<Parent: ResponseData>: FragmentTypeCase {
  typealias FragmentType = WarmBloodedDetails  

  let data: FieldData
  let parent: Parent
  private(set) lazy var fragments = Fragments(parent: parent, data: data)

  required init(parent: Parent, data: FieldData) {
    self.parent = parent
    self.data = data
  }

  final class Fragments: ToFragments<Parent, FieldData> {
    private(set) lazy var warmBloodedDetails = WarmBloodedDetails(data: self.data)
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
    return data.fields[keyPath: keyPath]
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Parent.Fields, T>) -> T {
    return parent.data.fields[keyPath: keyPath]
  }
}
