@propertyWrapper
public struct CacheField<T: Cacheable> {

  let field: StaticString

  public init(_ field: StaticString) {
    self.field = field
  }

  public static subscript<E: AnyCacheObject>(
    _enclosingInstance instance: E,
    wrapped wrappedKeyPath: ReferenceWritableKeyPath<E, T?>,
    storage storageKeyPath: ReferenceWritableKeyPath<E, Self>
  ) -> T? {
    get {
      let wrapper = instance[keyPath: storageKeyPath]
      let field = wrapper.field.description
      guard let data = instance.data[field] else {
        return nil
      }

      do {
        let value = try T.value(with: data, in: instance._transaction)
        try wrapper.replace(data: data, with: value, on: instance)
        return value

      } catch {
        instance._transaction.log(error)
        return nil
      }
    }
    set {
      let wrapper = instance[keyPath: storageKeyPath]
      let field = wrapper.field.description
      do {
//
//      switch newValue {
//      // case .none: // TODO
//      case is ScalarType:
        try instance.set(value: newValue, forField: wrapper)
////      case let entity as CacheEntity:
//
//
//
//      default:
//        break // TODO
//      }
      } catch let error as CacheError.Reason {
        let error = CacheError(
          reason: error,
          type: .write,
          field: field,
          object: entity(for: instance)
        )
        instance._transaction.log(error)

      } catch {
        instance._transaction.log(error)
      }
    }
  }

  private func replace(
    data: Any,
    with parsedValue: T,
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
      try instance.set(value: parsedValue, forField: self)

//    case let interface as CacheInterface where instance is CacheInterface:
//      try instance.set(value: entity, forField: self)
//      break // TODO

    case is CacheInterface, is ScalarType: break
    default: break
    }
  }

  private static func entity(for instance: AnyCacheObject) -> CacheEntity {
    switch instance {
    case let entity as CacheEntity: return entity
    case let interface as CacheInterface: return interface.entity
    default: fatalError("AnyCacheObject can only be a CacheEntity or a CacheInterface.")
    }
  }

//  public var projectedValue: CacheField { self }

  @available(*, unavailable,
  message: "This property wrapper can only be applied to AnyCacheObjects."
  )
  public var wrappedValue: T? { get { fatalError() } set { fatalError() } }
}
