//
//  ResponseObjectClasses.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/18/21.
//

import Foundation

/// An abstract base class for any data object that is part of the response
/// data for a `GraphQLOperation`.
///
/// This class uses `@dynamicMemberLookup` to provide accessors to all of the fields and
/// type conditions on the provided `Fields` and `TypeConditions` objects.
///
/// - Generic Parameters:
///   - `Fields`: An object that stores the fields fetched and stored directly on this object.
///   - `TypeConditions`: [optional] An object that stores the `TypeCondition`s that the object may be
///                  and their fields. Defaults to `Void`.
@dynamicMemberLookup
class ResponseObjectBase<Fields: FieldData>: FieldData, ResponseObject {

  typealias TypeCondition<SubtypeFields: FieldData> =
    TypeConditionBase<SubtypeFields, ResponseObjectBase<Fields>>

//  final let data: [String: Any] // Do we need this here, or just on Fields?
  private(set) lazy final var fields: Fields = Fields(data: data)

  final subscript<T>(dynamicMember keyPath: KeyPath<Fields, T>) -> T {
    return fields[keyPath: keyPath]
  }
}

class TypeConditionBase<Fields: FieldData, Parent: ResponseObject>:
  ResponseObjectBase<Fields>, TypeCondition {

//  typealias BaseClass = TypeConditionBase<Fields, Parent>

  static var possibleTypes: [String] { [] } // TODO
}
