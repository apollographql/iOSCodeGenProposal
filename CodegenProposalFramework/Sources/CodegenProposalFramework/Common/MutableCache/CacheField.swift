@propertyWrapper
public struct CacheField<T: Cacheable> {

  private let field: StaticString

  public init(_ field: StaticString) {
    self.field = field
  }

  public static subscript<E: AnyCacheObject>(
    _enclosingInstance instance: E,
    wrapped wrappedKeyPath: ReferenceWritableKeyPath<E, T?>,
    storage storageKeyPath: ReferenceWritableKeyPath<E, Self>
  ) -> T? {
    get {
      let field = instance[keyPath: storageKeyPath].field.description
      guard let data = instance.data[field] else {
        return nil
      }

      do {
        let value = try T.value(with: data, in: instance._transaction)
        replace(data: data, with: value, for: field, on: instance)
        return value

      } catch {
        instance._transaction.log(error: error)
        return nil
      }
    }
    set {
      //      let field = instance[keyPath: storageKeyPath].field
      //
      //      switch newValue {
      //      case let reference as AnyCacheReference:
      //        instance.data[field] = reference.cacheData
      //
      //      default:
      //        break // TODO
      ////        fatalError() // TODO
      //      }
    }
  }

  private static func replace(
    data: Any,
    with parsedValue: T,
    for field: String,
    on instance: AnyCacheObject)
  {
    /// Only need to do this for CacheEntity, Enums, and custom scalars.
    /// DO NOT DO THIS when value is a CacheInterface ON a CacheInterface instance
    /// For ScalarTypes, its redundant
    /// TODO: Write tests for this.
    switch (parsedValue) {
    case is CacheEntity where !(data is CacheEntity),
         is CacheInterface where instance is CacheInterface,
         is CustomScalarType:
      instance.mutateData { $0[field.description] = parsedValue }

    case is CacheInterface, is ScalarType: break
    default: break
    }
  }

  public var projectedValue: CacheField { self }

  @available(*, unavailable,
  message: "This property wrapper can only be applied to AnyCacheObjects."
  )
  public var wrappedValue: T? { get { fatalError() } set { fatalError() } }
}

/// A type that can be the value of a `@CacheField` property. In other words, a `Cacheable` type
/// can be the value of a field on a `CacheEntity` or `CacheInterface`
///
/// # Conforming Types:
/// - `CacheEntity`
/// - `CacheInterface`
/// - `ScalarType` (`String`, `Int`, `Bool`, `Float`)
/// - `CustomScalarType`
/// - `GraphQLEnum` (via `CustomScalarType`)
public protocol Cacheable {
  static func value(with cacheData: Any, in transaction: CacheTransaction) throws -> Self
}
