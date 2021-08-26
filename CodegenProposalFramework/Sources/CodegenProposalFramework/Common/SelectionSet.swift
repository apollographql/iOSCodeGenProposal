public enum SelectionSetType<S: SchemaTypeMetadata> {
  case ObjectType(CacheEntity.Type)
  case Interface(CacheInterface.Type)
  case Union(S.Union)
}

public protocol SelectionSet: ResponseObject {

  associatedtype Schema: SchemaTypeMetadata

  /// The GraphQL type for the `SelectionSet`.
  ///
  /// This may be a concrete type (`ConcreteType`) or an abstract type (`Interface`, or `Union`).
  static var __parentType: SelectionSetType<Schema> { get }
}

extension SelectionSet {

  var __objectType: CacheEntity.Type? { Schema.entityType(forTypename: __typename) }
//    Schema.ObjectType(rawValue: __typename) ?? .unknownCase }

  var __typename: String { data["__typename"] }

  /// Verifies if a `SelectionSet` may be converted to a different `SelectionSet` and performs
  /// the conversion.
  ///
  /// - Warning: This function is not supported for use outside of generated call sites.
  /// Generated call sites are guaranteed by the GraphQL compiler to be safe.
  /// Unsupported usage may result in unintended consequences including crashes.
  func _asType<T: SelectionSet>() -> T? where T.Schema == Schema {
    guard let __objectType = __objectType else { return nil }

    switch T.__parentType {
    case .ObjectType(let type):
      guard __objectType == type else { return nil }

    case .Interface(let interface):
      guard __objectType.__metadata.implements(interface) else { return nil }

    case .Union(let union):
      guard union.possibleTypes.contains(where: { $0 == __objectType }) else { return nil }
    }

    return T.init(data: data)
  }
}

public protocol ResponseObject {
  var data: ResponseDict { get }

  init(data: ResponseDict)
}

extension ResponseObject {

  /// Converts a `SelectionSet` to a `Fragment` given a generic fragment type.
  ///
  /// - Warning: This function is not supported for use outside of generated call sites.
  /// Generated call sites are guaranteed by the GraphQL compiler to be safe.
  /// Unsupported usage may result in unintended consequences including crashes.
  func _toFragment<T: Fragment>() -> T {
    return T.init(data: data)
  }
}
