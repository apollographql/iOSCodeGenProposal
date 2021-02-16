//
//  ToFragments.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/16/21.
//

import Foundation

/// An abstract base class for a `Fragments` object on a `ResponseData` object that
/// conforms to `HasFragments`.
///
/// `ResponseData` objects can be generated with subclasses of this object that provide
/// accessors to convert the object into any included fragments.
///
/// If the object has a parent, fragments from the parent will also be accessible.
@dynamicMemberLookup
class ToFragments<Parent, Fields> {
  let parent: Parent
  let fields: Fields

  internal init(parent: Parent, fields: Fields) {
    self.parent = parent
    self.fields = fields
  }
}

extension ToFragments where Parent: HasFragments {
  subscript<T>(dynamicMember keyPath: KeyPath<Parent.Fragments, T>) -> T {
    return parent.fragments[keyPath: keyPath]
  }
}
