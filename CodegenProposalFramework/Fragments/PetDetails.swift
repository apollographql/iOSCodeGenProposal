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

  let fields: Fields

  init(fields: Fields) {
    self.fields = fields
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
    return fields[keyPath: keyPath]
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

  let fields: Fields
  let parent: Parent
  private(set) lazy var fragments = Fragments(parent: parent, fields: fields)

  required init(parent: Parent, fields: Fields, typeCaseFields: Void = ()) {
    self.parent = parent
    self.fields = fields
  }

  final class Fragments: ToFragments<Parent, Fields> {
    private(set) lazy var petDetails = PetDetails(fields: self.fields)
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
    return fields[keyPath: keyPath]
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Parent.Fields, T>) -> T {
    return parent.fields[keyPath: keyPath]
  }
}
