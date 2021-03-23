/// A structure that wraps the underlying data dictionary used by `SelectionSet`s.
struct ResponseDict {

  let data: [String: Any]

  subscript<T: ScalarType>(_ key: String) -> T {
    data[key] as! T
  }

  subscript<T:ScalarType>(_ key: String) -> T? {
    data[key] as? T
  }

  subscript<T: SelectionSet>(_ key: String) -> T {
    let entityData = data[key] as! [String: Any]
    return T.init(data: ResponseDict(data: entityData))
  }

  subscript<T: SelectionSet>(_ key: String) -> T? {
    guard let entityData = data[key] as? [String: Any] else { return nil }
    return T.init(data: ResponseDict(data: entityData))
  }

  subscript<T: SelectionSet>(_ key: String) -> [T] {
    let entityData = data[key] as! [[String: Any]]
    return entityData.map { T.init(data: ResponseDict(data: $0)) }
  }

  subscript<T>(_ key: String) -> GraphQLEnum<T> {
    let entityData = data[key] as! String
    return GraphQLEnum(rawValue: entityData)
  }

  subscript<T>(_ key: String) -> GraphQLEnum<T>? {
    guard let entityData = data[key] as? String else { return nil }
    return GraphQLEnum(rawValue: entityData)
  }
}

protocol ResponseObject {
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
