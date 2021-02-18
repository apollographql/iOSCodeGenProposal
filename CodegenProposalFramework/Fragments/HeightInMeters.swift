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

  let data: FieldData<Fields, Void>

  init(data: ResponseData) {
    self.data = data
  }

  init(height: Height) {
    self.data = .init(fields: Fields(height: height))
  }

  final class Height: ResponseObject {
    final class Fields {
      let meters: Int

      init(meters: Int) {
        self.meters = meters
      }
    }

    let data: FieldData<Fields, Void>

    init(data: ResponseData) {
      self.data = data
    }

    init(meters: Int) {
      self.data = .init(fields: Fields(meters: meters))
    }

    subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
      return data.fields[keyPath: keyPath]
    }
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
    return data.fields[keyPath: keyPath]
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
class AsHeightInMeters<Parent: ResponseObject>: FragmentTypeCase {
  typealias FragmentType = HeightInMeters

  let data: FieldData<HeightInMeters.Fields, Void>
  let parent: Parent
  private(set) lazy var fragments = Fragments(parent: parent, data: data)

  required init(parent: Parent, data: ResponseData) {
    self.parent = parent
    self.data = data
  }
  
  final class Fragments: ToFragments<Parent, ResponseData> {
    private(set) lazy var heightInMeters = HeightInMeters(data: self.data)
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
    return data.fields[keyPath: keyPath]
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Parent.Fields, T>) -> T {
    return parent.data.fields[keyPath: keyPath]
  }
}
