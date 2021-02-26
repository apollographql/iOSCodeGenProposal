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
@dynamicMemberLookup
class FragmentJoiner<Parent: ResponseObject>: FieldData {}

extension FragmentJoiner where Parent: HasFragments {
  subscript<T>(dynamicMember keyPath: KeyPath<Parent.Fragments, T>) -> T {
    return Parent.Fragments.init(data: data)[keyPath: keyPath]
  }
}

@propertyWrapper
struct ToFragment<Value: Fragment> {

  static subscript<T: FieldData>(
    _enclosingInstance instance: T,
    wrapped wrappedKeyPath: KeyPath<T, Value>,
    storage storageKeyPath: KeyPath<T, Self>
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

//@dynamicMemberLookup
//class FragmentJoiner<T: ResponseObject & HasFragments, U: ResponseObject>: FieldData {
//  let first: T.Fragments
//  let second: U.Fields
//
//  init(first: T, second: U) {
//    self.first = first.fields
//    self.second = second.fields
//    super.init(data: first.data)
//  }
//
//  required init(data: [String : Any]) {
//    self.first = T.Fields(data: data)
//    self.second = U.Fields(data: data)
//    super.init(data: data)
//  }
//
//  subscript<Value>(dynamicMember keyPath: KeyPath<T.Fields, Value>) -> Value {
//    first[keyPath: keyPath]
//  }
//
//  subscript<Value>(dynamicMember keyPath: KeyPath<U.Fields, Value>) -> Value {
//    second[keyPath: keyPath]
//  }
//}
