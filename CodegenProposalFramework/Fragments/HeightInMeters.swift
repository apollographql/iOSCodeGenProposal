//
//  HeightInMeters.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/16/21.
//

import Foundation

/// A response data object for a `HeightInMeters` fragment
///
/// ```
/// fragment HeightInMeters on Animal {
///   height {
///     meters
///   }
/// }
/// ```
final class HeightInMeters: Fragment {
  final class Fields {
    let height: Height

    init(height: Height) {
      self.height = height
    }
  }

  let fields: Fields

  init(fields: Fields) {
    self.fields = fields
  }

  init(height: Height) {
    self.fields = Fields(height: height)
  }

  final class Height: ResponseData {
    final class Fields {
      let meters: Int

      init(meters: Int) {
        self.meters = meters
      }
    }

    let fields: Fields

    init(fields: Fields) {
      self.fields = fields
    }

    init(meters: Int) {
      self.fields = Fields(meters: meters)
    }

    subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
      return fields[keyPath: keyPath]
    }
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
    return fields[keyPath: keyPath]
  }
}

/// A generic type case for a `HeightInMeters` fragment
///
/// ```
/// fragment HeightInMeters on Animal {
///   height {
///     meters
///   }
/// }
/// ```
class AsHeightInMeters<Parent: ResponseData>: FragmentTypeCase {
  typealias FragmentType = HeightInMeters

  let fields: Fields
  let parent: Parent
  private(set) lazy var fragments = Fragments(parent: parent, fields: fields)

  required init(parent: Parent, fields: Fields, typeCaseFields: Void = ()) {
    self.parent = parent
    self.fields = fields
  }
  
  final class Fragments: ToFragments<Parent, Fields> {
    private(set) lazy var heightInMeters = HeightInMeters(fields: self.fields)
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
    return fields[keyPath: keyPath]
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Parent.Fields, T>) -> T {
    return parent.fields[keyPath: keyPath]
  }
}
