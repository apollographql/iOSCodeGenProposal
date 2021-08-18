public protocol CacheEntityFactory {
  static func entityType(forTypename __typename: String) -> CacheEntity.Type?
}

public protocol CacheTransaction: AnyObject {
  var entityFactory: CacheEntityFactory.Type { get }

  func entity<T>(withKey: String) -> T?

  func cacheKey(for: CacheEntity) -> CacheKey?
}

extension CacheTransaction {
  func entity<T: CacheEntity>(withData data: [String: Any]) -> T {
    guard let typename = data["__typename"] as? String,
          let type = entityFactory.entityType(forTypename: typename) else {
      fatalError()
    }

    return type.init(in: self, data: data) as! T
  }
}

open class CacheEntity: AnyCacheEntity {
  let _transaction: CacheTransaction
  public var data: [String: Any]

  public required init(in transaction: CacheTransaction, data: [String: Any] = [:]) {
    self._transaction = transaction
    self.data = data
  }

//  var cacheKey: String { "" } // TODO
}

protocol AnyCacheReference {
  var cacheData: Any { get }
}

//protocol CacheReferenceProtocol {
//  associatedtype Entity
//  func resolve() -> Entity?
//}

public enum CacheReference<T>: AnyCacheReference {
  case ref(CacheKey, CacheTransaction)
  case entity(T)

  func resolve() -> T? {
    switch self {
    case let .ref(key, transaction):
      return transaction.entity(withKey: key.key)
    case let .entity(entity):
      return entity
    }
  }

  var cacheData: Any {
    switch self {
    case let .ref(key, _):
      return key
    case let .entity(entity as CacheEntity):
      return entity.data
    default:
      fatalError() // TODO: Error Handling
    }
  }
}



/// Represents a key that references a record in the cache.
public struct CacheKey {
  public let key: String

  public init(key: String) {
    self.key = key
  }
}

extension CacheEntity {
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

        if let _ = data as? CacheKey {
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
}


public protocol AnyCacheEntity {
  var data: [String: Any] { get }
}

public class SomeEntity<T> {
//  private struct AnyCacheReference {
//    let value: CacheReferenceProtocol
//  }

  private let wrapped: T?

  public init?(wrapping reference: AnyCacheEntity?) {
    guard let ref = reference as? T else { return nil }
    self.wrapped = ref
  }
}
