protocol SchemaTypeEnum: RawRepresentable where RawValue == String {}

protocol SchemaObjectType: SchemaTypeEnum {
  associatedtype Interface

  static var unknownCase: Self { get }

  func implements(_ interface: Interface) -> Bool
}

protocol GraphQLSchema {
  associatedtype ObjectType: SchemaObjectType where ObjectType.Interface == Self.Interface
  associatedtype Interface: SchemaTypeEnum
  associatedtype Union: SchemaTypeEnum
}
