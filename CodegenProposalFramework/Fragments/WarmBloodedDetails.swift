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

  let fields: Fields

  init(fields: Fields) {
    self.fields = fields
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

    let fields: Fields

    init(fields: Fields) {
      self.fields = fields
    }

    subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
      return fields[keyPath: keyPath]
    }
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
    return fields[keyPath: keyPath]
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

  let fields: Fields
  let parent: Parent
  private(set) lazy var fragments = Fragments(parent: parent, fields: fields)

  required init(parent: Parent, fields: Fields, typeCaseFields: Void = ()) {
    self.parent = parent
    self.fields = fields
  }

  final class Fragments: ToFragments<Parent, Fields> {
    private(set) lazy var warmBloodedDetails = WarmBloodedDetails(fields: self.fields)
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
    return fields[keyPath: keyPath]
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Parent.Fields, T>) -> T {
    return parent.fields[keyPath: keyPath]
  }
}
