//
//  PetDetails.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/16/21.
//

import Foundation

/// A response data object for a `PetDetails` fragment
///
/// ```
/// fragment PetDetails on Pet {
///  humanName
///  favoriteToy
/// }
/// ```
final class PetDetails: Fragment {
  final class Fields {
    let humanName: String
    let favoriteToy: String

    init(humanName: String, favoriteToy: String) {
      self.humanName = humanName
      self.favoriteToy = favoriteToy
    }
  }

  let data: ResponseDataFields<Fields, Void>

  init(data: FieldData) {
    self.data = data
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
    return data.fields[keyPath: keyPath]
  }
}

/// A generic type case for a `PetDetails` fragment.
///
/// ```
/// fragment PetDetails on Pet {
///  humanName
///  favoriteToy
/// }
/// ```
class AsPetDetails<Parent: ResponseData>: FragmentTypeCase {
  typealias FragmentType = PetDetails

  let data: FieldData
  let parent: Parent
  private(set) lazy var fragments = Fragments(parent: parent, data: data)

  required init(parent: Parent, data: FieldData) {
    self.parent = parent
    self.data = data
  }

  final class Fragments: ToFragments<Parent, FieldData> {
    private(set) lazy var petDetails = PetDetails(data: self.data)
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
    return data.fields[keyPath: keyPath]
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Parent.Fields, T>) -> T {
    return parent.data.fields[keyPath: keyPath]
  }
}
