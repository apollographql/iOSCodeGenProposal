/// A structure that wraps the underlying data dictionary used by `SelectionSet`s.
struct ResponseData {

  let data: [String: Any]

  subscript<T: ScalarType>(_ key: String) -> T {
    data[key] as! T
  }

  subscript<T: SelectionSet>(_ key: String) -> T {
    let entityData = data[key] as! [String: Any]
    return T.init(data: ResponseData(data: entityData))
  }

  subscript<T: SelectionSet>(_ key: String) -> [T] {
    let entityData = data[key] as! [[String: Any]]
    return entityData.map { T.init(data: ResponseData(data: $0)) }
  }
}

protocol ResponseObject {
  var data: ResponseData { get }

  init(data: ResponseData)
}

extension ResponseObject {
  func toFragment<T: SelectionSet>() -> T {
    return T.init(data: data)
  }
}
