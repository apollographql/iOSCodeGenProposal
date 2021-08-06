@propertyWrapper
public struct CacheField<T> {

  private let field: StaticString

  public init(_ field: StaticString) {
    self.field = field
  }

  public static subscript<E: CacheEntity>(
    _enclosingInstance instance: E,
    wrapped wrappedKeyPath: ReferenceWritableKeyPath<E, T?>,
    storage storageKeyPath: ReferenceWritableKeyPath<E, Self>
  ) -> T? {
    get {
      let field = instance[keyPath: storageKeyPath].field
      let data = instance.data[field.description]

      if let cacheKey = data as? CacheKey {
        fatalError()
//        return CacheReference.entity(instance._transaction.entity(withKey: cacheKey.key)) as? T

      } else if let dataDict = data as? [String: Any] {
//          let entity = instance._transaction.entity(withData: dataDict)
//          return CacheReference.entity(entity) as! T // CacheReference<CacheEntity>
        fatalError()

      } else {
        return data as? T
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

  public var projectedValue: CacheField { self }

  @available(*, unavailable,
      message: "This property wrapper can only be applied to CacheEntity objects."
  )
  public var wrappedValue: T? { get { fatalError() } set { fatalError() } }
}


@propertyWrapper
public struct CacheRef<R> {

  private let field: StaticString

  public init(_ field: StaticString) {
    self.field = field
  }

  public static subscript<E: CacheEntity, R>(
    _enclosingInstance instance: E,
    wrapped wrappedKeyPath: ReferenceWritableKeyPath<E, CacheReference<R>?>,
    storage storageKeyPath: ReferenceWritableKeyPath<E, Self>
  ) -> CacheReference<R>? {
    get {
      let field = instance[keyPath: storageKeyPath].field
      let data = instance.data[field.description]

      if let cacheKey = data as? CacheKey {
        fatalError()
//        return CacheReference.entity(instance._transaction.entity(withKey: cacheKey.key)) as? T

      } else if let dataDict = data as? [String: Any] {
        let entity: R = instance._transaction.entity(withData: dataDict) as! R
        return CacheReference.entity(entity)
//        fatalError()

      } else {
        fatalError()
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

  public var projectedValue: CacheRef { self }

  @available(*, unavailable,
      message: "This property wrapper can only be applied to CacheEntity objects."
  )
  public var wrappedValue: CacheReference<R>? { get { fatalError() } set { fatalError() } }
}
