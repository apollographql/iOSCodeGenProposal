public protocol SchemaTypeFactory {
  static func entityType(forTypename __typename: String) -> CacheEntity.Type?
}
