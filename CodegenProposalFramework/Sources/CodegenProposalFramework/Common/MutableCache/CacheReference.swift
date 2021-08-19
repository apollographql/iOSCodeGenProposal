public protocol AnyCacheObject: AnyObject {
  var _transaction: CacheTransaction { get }
  var data: [String: Any] { get }
}

open class CacheEntity: AnyCacheObject, Cacheable {
  public let _transaction: CacheTransaction
  public var data: [String: Any]

  final var __typename: String { data["__typename"] as! String }

  public required init(transaction: CacheTransaction, data: [String: Any] = [:]) {
    self._transaction = transaction
    self.data = data
  }

  public static func value(
    with cacheData: Any,
    in transaction: CacheTransaction
  ) throws -> Self {
    switch cacheData {
    case let dataAsSelf as Self:
      return dataAsSelf

    case let key as CacheKey:
      return transaction.entity(withKey: key) as! Self

    case let data as [String: Any]:
      return transaction.entity(withData: data) as! Self

    default:
      throw CacheReadError.Reason.unrecognizedCacheData(cacheData, forType: Self.self) // TODO
    }
  }

  //  var cacheKey: String { "" } // TODO
}

open class CacheInterface: AnyCacheObject {

  final let underlyingEntity: CacheEntity
  final var underlyingType: CacheEntity.Type { type(of: underlyingEntity) }

  public final var _transaction: CacheTransaction { underlyingEntity._transaction }
  public final var data: [String: Any] { underlyingEntity.data }

  public required init(entity: CacheEntity) {
    self.underlyingEntity = entity
  }

  public static func value(
    with cacheData: Any,
    in transaction: CacheTransaction
  ) throws -> Self {
    switch cacheData {
    case let entity as CacheEntity:
      return Self.init(entity: entity)

    case let key as CacheKey:
      return Self.init(entity: transaction.entity(withKey: key)!)

    case let data as [String: Any]:
      return Self.init(entity: transaction.entity(withData: data))

    default:
      throw CacheReadError.Reason.unrecognizedCacheData(cacheData, forType: Self.self) // TODO
    }
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

/// Represents a key that references a record in the cache.
public struct CacheKey: Hashable {
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
