@propertyWrapper
public struct CacheField<T> {

  private let field: String

  public init(_ field: String) {
    self.field = field
  }

  public static subscript<E: CacheEntity>(
    _enclosingInstance instance: E,
    wrapped wrappedKeyPath: ReferenceWritableKeyPath<E, T?>,
    storage storageKeyPath: ReferenceWritableKeyPath<E, Self>
  ) -> T? {
    get {
      let field = instance[keyPath: storageKeyPath].field
      let data = instance.data[field]
      if let cacheKey = data as? CacheKey {
        return instance._transaction.entity(withKey: cacheKey.key) as? T

      } else if let dataDict = data as? [String: Any] {
        return instance._transaction.entity(withData: dataDict) as? T

      } else {
        return data as? T
      }
    }
    set {
      // TODO
//      var storage = instance[keyPath: storageKeyPath]
//      storage.value = newValue
//      storage.cacheKey = newValue?.cacheKey
    }
  }

  @available(*, unavailable,
      message: "This property wrapper can only be applied to classes"
  )
  public var wrappedValue: T? {
      get { fatalError() }
      set { fatalError() }
  }

  public var projectedValue: CacheField { self }
}
