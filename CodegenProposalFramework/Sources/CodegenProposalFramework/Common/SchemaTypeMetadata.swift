/// A protocol that a generated GraphQL Schema should conform to.
///
/// A `GraphQLSchema` contains information on the types within a schema and their relationships
/// to other types. This information is used to verify that a `SelectionSet` can be converted to
/// a given type condition.
public protocol SchemaTypeMetadata: CacheEntityFactory {
  associatedtype ObjectType: SchemaObjectType
  associatedtype Union: SchemaUnion where Union.ObjectType == Self.ObjectType
  associatedtype Interface where ObjectType.Interface == Interface
}

extension SchemaTypeMetadata {
  static func entityType(forTypename __typename: String) -> CacheEntity.Type? {
    ObjectType.init(rawValue: __typename)?.entityType
  }
}

public protocol SchemaTypeEnum: RawRepresentable, Hashable where RawValue == String {}

public protocol SchemaObjectType: SchemaTypeEnum {
  associatedtype Interface: SchemaTypeEnum

  static var unknownCase: Self { get }

  var implementedInterfaces: Set<Interface> { get }

  var entityType: CacheEntity.Type? { get }
}

extension SchemaObjectType {
  func implements(_ interface: Interface) -> Bool {
    implementedInterfaces.contains(interface)
  }
}

public protocol SchemaUnion: SchemaTypeEnum {
  associatedtype ObjectType

  var possibleTypes: [ObjectType] { get }
}