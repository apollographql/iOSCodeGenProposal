protocol SchemaTypeEnum: RawRepresentable where RawValue == String {}

protocol SchemaObjectType: SchemaTypeEnum {
  associatedtype Interface: SchemaTypeEnum
  func implements(_ interface: Interface) -> Bool
}

protocol GraphQLSchema {
  associatedtype ObjectType: SchemaObjectType where ObjectType.Interface == Self.Interface
  associatedtype Interface
}
