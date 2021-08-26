public protocol SchemaTypeFactory {
  static func entityType(forTypename __typename: String) -> CacheEntity.Type?
}

public protocol SchemaUnion { // TODO: convert to use mutable cache entities?
  var possibleTypes: [CacheEntity.Type] { get }
}
