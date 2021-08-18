extension CacheEntity {
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
        return data as? T
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
}
