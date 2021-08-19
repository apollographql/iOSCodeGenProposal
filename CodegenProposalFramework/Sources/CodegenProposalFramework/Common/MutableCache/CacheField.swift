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
      let field = instance[keyPath: storageKeyPath].field
      guard let data = instance.data[field.description],
            let value = try? T.value(with: data, in: instance._transaction) else {
        return nil
      }

      // instance.data[field.description] = value
      return value
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
  message: "This property wrapper can only be applied to AnyCacheObjects."
  )
  public var wrappedValue: T? { get { fatalError() } set { fatalError() } }
}

public protocol Cacheable {
  static func value(with cacheData: Any, in transaction: CacheTransaction) throws -> Self
//  init(cacheData: Any, transaction: CacheTransaction) throws
  //  var cacheData: Any { get }
}
