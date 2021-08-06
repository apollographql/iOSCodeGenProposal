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

//@propertyWrapper
//public struct CacheReference<T> {
//
//  private let field: String // TODO: Use StaticString?
//
//  public init(_ field: String) {
//    self.field = field
//  }
//
//  public static subscript<E: CacheEntity>(
//    _enclosingInstance instance: E,
//    wrapped wrappedKeyPath: ReferenceWritableKeyPath<E, T?>,
//    storage storageKeyPath: ReferenceWritableKeyPath<E, Self>
//  ) -> T? {
//    get {
//      let field = instance[keyPath: storageKeyPath].field
//      let data = instance.data[field]
//      if let cacheKey = data as? CacheKey {
//        return instance._transaction.entity(withKey: cacheKey.key)
//
//      } else if let dataDict = data as? [String: Any] {
//        return instance._transaction.entity(withData: dataDict)
//
//      } else {
//        return data as? T
//      }
//    }
//    set {
//      let field = instance[keyPath: storageKeyPath].field
//
//      switch newValue {
//      case let entity as AnyCacheEntity:
//        instance.data[field] = entity.data
//
//      default:
//        break // TODO
////        fatalError() // TODO
//      }
//    }
//  }
//
//  public var projectedValue: CacheReference { self }
//
//  @available(*, unavailable,
//      message: "This property wrapper can only be applied to CacheEntity objects."
//  )
//  public var wrappedValue: T? { get { fatalError() } set { fatalError() } }
//}

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
