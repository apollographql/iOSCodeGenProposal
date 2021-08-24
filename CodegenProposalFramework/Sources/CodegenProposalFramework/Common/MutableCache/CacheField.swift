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
        try replace(data: data, with: value, for: field, on: instance)
        return value

      } catch {
        instance._transaction.log(error: error)
        return nil
      }
    }
    set {
      let field = instance[keyPath: storageKeyPath].field.description
      do {
//
//      switch newValue {
//      // case .none: // TODO
//      case is ScalarType:
        try instance.set(value: newValue, forField: field)
////      case let entity as CacheEntity:
//
//
//
//      default:
//        break // TODO
//      }
      } catch {
        instance._transaction.log(error: error)
      }
    }
  }

  private static func replace(
    data: Any,
    with parsedValue: T,
    for field: String,
    on instance: AnyCacheObject
  ) throws {
    /// Only need to do this for CacheEntity, Enums, and custom scalars.
    /// DO NOT DO THIS when value is a CacheInterface ON a CacheInterface instance
    /// For ScalarTypes, its redundant
    /// TODO: Write tests for this.
    switch (parsedValue) {
    case is CacheEntity where !(data is CacheEntity),
         is CacheInterface where instance is CacheEntity,
         is CustomScalarType:
      try instance.set(value: parsedValue, forField: field)

    case let interface as CacheInterface where instance is CacheInterface:
      try instance.set(value: interface.entity, forField: field)
      break // TODO

    case is CacheInterface, is ScalarType: break
    default: break
    }
  }

//  public var projectedValue: CacheField { self }

  @available(*, unavailable,
  message: "This property wrapper can only be applied to AnyCacheObjects."
  )
  public var wrappedValue: T? { get { fatalError() } set { fatalError() } }
}
