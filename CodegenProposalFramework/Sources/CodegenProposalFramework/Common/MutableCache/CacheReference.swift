public protocol CacheEntityFactory {
  static func entityType(forTypename __typename: String) -> CacheEntity.Type?
}

public protocol CacheTransaction: AnyObject {
  var entityFactory: CacheEntityFactory.Type { get }

  func entity<T>(withKey: CacheKey) -> T?

  func cacheKey(for: CacheEntity) -> CacheKey?
}

extension CacheTransaction {
  func entity<T>(withData data: [String: Any]) -> T {
    guard let typename = data["__typename"] as? String,
          let type = entityFactory.entityType(forTypename: typename),
          type == T.self else {
      fatalError()
    }

    return type.init(in: self, data: data) as! T
  }
}

struct CacheReadError: Error {
  enum Reason: Error {
    case unrecognizedCacheData(_ data: Any, forType: Any.Type)
  }
  let reason: Reason
  let field: String
  let object: AnyCacheObject?
}

public protocol AnyCacheObject: AnyObject {
  var _transaction: CacheTransaction { get }
  var data: [String: Any] { get }
}

open class CacheEntity: AnyCacheObject {
  public let _transaction: CacheTransaction
  public var data: [String: Any]

  public required init(in transaction: CacheTransaction, data: [String: Any] = [:]) {
    self._transaction = transaction
    self.data = data
  }

  final var __typename: String { data["__typename"] as! String }

  //  var cacheKey: String { "" } // TODO
}

open class CacheInterface: AnyCacheObject {

  final let underlyingEntity: CacheEntity
  final var underlyingType: CacheEntity.Type { type(of: underlyingEntity) }

  public final var _transaction: CacheTransaction { underlyingEntity._transaction }
  public final var data: [String: Any] { underlyingEntity.data }

  init(entity: CacheEntity) {
    self.underlyingEntity = entity
  }

//  func asUnderlyingType() -> CacheEntity {
//    underlyingType.init(in: _transaction, data: data)
//  }
//
//  func `as`<T: CacheEntity>(type: T.Type) -> T? {
//    T.init(in: _transaction, data: data) // TODO: Type conversion checking
//  }
//
//  func `as`<T: CacheInterface>(type: T.Type) -> T? {
//    T.init(in: _transaction, data: data) // TODO: Type conversion checking
//  }
}

protocol AnyCacheReference {
  var cacheData: Any { get }
}

//protocol CacheReferenceProtocol {
//  associatedtype Entity
//  func resolve() -> Entity?
//}

public enum CacheReference<T>: AnyCacheReference, Cacheable { // TODO: experiment with dynamic member lookup that resolves the object?
  case ref(CacheKey, CacheTransaction)
  case entity(T)

  public init(cacheData: Any, transaction: CacheTransaction) throws {
    switch cacheData {
    case let key as CacheKey:
      self = .ref(key, transaction)
    case let data as [String: Any]:
      self = .entity(transaction.entity(withData: data))
    default:
      throw CacheReadError.Reason.unrecognizedCacheData(cacheData, forType: T.self)
    }
  }

  func resolve() -> T? {
    switch self {
    case let .ref(key, transaction):
      return transaction.entity(withKey: key)
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

//extension CacheEntity {
//  @propertyWrapper
//  public struct CacheRef<R: CacheEntity> {
//
//    private let field: StaticString
//
//    public init(_ field: StaticString) {
//      self.field = field
//    }
//
//    public static subscript<E: CacheEntity, R>(
//      _enclosingInstance instance: E,
//      wrapped wrappedKeyPath: ReferenceWritableKeyPath<E, CacheReference<R>?>,
//      storage storageKeyPath: ReferenceWritableKeyPath<E, Self>
//    ) -> CacheReference<R>? {
//      get {
//        let field = instance[keyPath: storageKeyPath].field
//        let data = instance.data[field.description]
//
//        if let _ = data as? CacheKey {
//          fatalError()
//          //        return CacheReference.entity(instance._transaction.entity(withKey: cacheKey.key)) as? T
//
//        } else if let dataDict = data as? [String: Any] {
////          let entity: R = instance._transaction.entity(withData: dataDict) as! R
////          return CacheReference.entity(entity)
//                  fatalError()
//
//        } else {
//          fatalError()
//        }
//      }
//      set {
//        //      let field = instance[keyPath: storageKeyPath].field
//        //
//        //      switch newValue {
//        //      case let reference as AnyCacheReference:
//        //        instance.data[field] = reference.cacheData
//        //
//        //      default:
//        //        break // TODO
//        ////        fatalError() // TODO
//        //      }
//      }
//    }
//
//    public var projectedValue: CacheRef { self }
//
//    @available(*, unavailable,
//    message: "This property wrapper can only be applied to CacheEntity objects."
//    )
//    public var wrappedValue: CacheReference<R>? { get { fatalError() } set { fatalError() } }
//  }
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
