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
final class PetDetails: ResponseObjectBase<PetDetails.Fields, Void>, Fragment {
  final class Fields {
    let humanName: String
    let favoriteToy: String

    init(humanName: String, favoriteToy: String) {
      self.humanName = humanName
      self.favoriteToy = favoriteToy
    }
  }

  convenience init(humanName: String, favoriteToy: String) {
    self.init(fields: Fields(humanName: humanName, favoriteToy: favoriteToy))
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
class AsPetDetails<Parent: ResponseObject>: FragmentTypeCase {
  typealias FragmentType = PetDetails

  let data: FieldData<PetDetails.Fields, Void>
  let parent: Parent
  private(set) lazy var fragments = Fragments(parent: parent, data: data)

  required init(parent: Parent, data: ResponseData) {
    self.parent = parent
    self.data = data
  }

  final class Fragments: ToFragments<Parent, ResponseData> {
    private(set) lazy var petDetails = PetDetails(data: self.data)
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
    return data.fields[keyPath: keyPath]
  }

  subscript<T>(dynamicMember keyPath: KeyPath<Parent.Fields, T>) -> T {
    return parent.data.fields[keyPath: keyPath]
  }
}
