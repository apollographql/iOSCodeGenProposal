/// A structure that wraps the underlying data dictionary used by `SelectionSet`s.
struct ResponseDict {

  let data: [String: Any]

  subscript<T: ScalarType>(_ key: String) -> T {
    data[key] as! T
  }

  subscript<T: SelectionSet>(_ key: String) -> T {
    let entityData = data[key] as! [String: Any]
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
}

protocol ResponseObject {
  var data: ResponseDict { get }

  init(data: ResponseDict)
}

extension ResponseObject {
  func toFragment<T: SelectionSet>() -> T {
    return T.init(data: data)
  }
}
