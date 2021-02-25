//
//  ToFragments.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/16/21.
//

import Foundation

/// An abstract base class for a `Fragments` object on a `ResponseObject` that
/// conforms to `HasFragments`.
///
/// A `ResponseObject` can be generated with subclasses of this object that provide
/// accessors to convert the object into any included fragments.
///
/// If the object has a parent, fragments from the parent will also be accessible.
//@dynamicMemberLookup
//class ToFragments<Parent, FieldData> {
//
//  let parent: Parent // TODO: We don't really need a reference to the parent,
//                     // just its Fragments (if the parent HasFragments)
//  let data: FieldData
//
//  required init(parent: Parent, data: FieldData) {
//    self.parent = parent
//    self.data = data
//  }
//}
//
//extension ToFragments where Parent: HasFragments {
//  subscript<T>(dynamicMember keyPath: KeyPath<Parent.Fragments, T>) -> T {
//    return parent.fragments[keyPath: keyPath]
//  }
//}

@propertyWrapper
struct ToFragment<Value: Fragment> {

  static subscript<T: FieldData>(
    _enclosingInstance instance: T,
    wrapped wrappedKeyPath: ReferenceWritableKeyPath<T, Value>,
    storage storageKeyPath: ReferenceWritableKeyPath<T, Self>
  ) -> Value {
    get {
      return Value(data: instance.data)
    }
  }

  @available(*, unavailable, message: "This property wrapper can only be applied to classes")
  var wrappedValue: Value {
      get { fatalError() }
  }

}
