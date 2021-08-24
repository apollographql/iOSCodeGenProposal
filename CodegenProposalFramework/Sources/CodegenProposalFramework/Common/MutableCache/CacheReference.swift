public protocol AnyCacheObject: AnyObject {
  var _transaction: CacheTransaction { get }
  var data: [String: Any] { get }

  func set(value: Cacheable?, forField field: String) throws

  func propertyType(forField field: String) -> Cacheable.Type?
}

/// A type that can be the value of a `@CacheField` property. In other words, a `Cacheable` type
/// can be the value of a field on a `CacheEntity` or `CacheInterface`
///
/// # Conforming Types:
/// - `CacheEntity`
/// - `CacheInterface`
/// - `ScalarType` (`String`, `Int`, `Bool`, `Float`)
/// - `CustomScalarType`
/// - `GraphQLEnum` (via `CustomScalarType`)
public protocol Cacheable {
  static func value(with cacheData: Any, in transaction: CacheTransaction) throws -> Self
}

open class CacheEntity: AnyCacheObject, Cacheable {
  public final let _transaction: CacheTransaction
  public final var data: [String: Any]

  final var __typename: String { data["__typename"] as! String }

  public struct Metadata {
    let implementedInterfaces: [CacheInterface.Type]

    public init(interfaces: [CacheInterface.Type]) {
      self.implementedInterfaces = interfaces
    }
  }

  open class var __metadata: Metadata { fatalError("Subclasses must override this property.") }

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
      throw MockError.mock// TODO
    }
  }

  public final func set(value: Cacheable?, forField field: String) throws {
    guard let value = value else {
      data[field] = nil
      return
    }

    switch propertyType(forField: field) {
    case let interface as CacheInterface.Type:
      data[field] = try interface.value(with: value, in: _transaction)

    default: break // TODO: throw error
    }
  }

  open func propertyType(forField field: String) -> Cacheable.Type? {
    fatalError("Subclasses must override this function.")
  }
}

enum MockError: Error {
  case mock // TODO
}

open class CacheInterface: AnyCacheObject, Cacheable {

  final let entity: CacheEntity
  final var underlyingType: CacheEntity.Type { Swift.type(of: entity) }

  public static var fields: [String : Cacheable.Type] { [:] }

  public final var _transaction: CacheTransaction { entity._transaction }
  public final var data: [String: Any] { entity.data }

  public required init(entity: CacheEntity) throws {
    let validInterfaces = type(of: entity).__metadata.implementedInterfaces
    guard validInterfaces.contains(where: {$0 == Self.self}) else {
      throw MockError.mock
    }

    self.entity = entity
  }

  public required convenience init(interface: CacheInterface) throws {
    try self.init(entity: interface.entity)
  }

  public static func value(
    with cacheData: Any,
    in transaction: CacheTransaction
  ) throws -> Self {
    switch cacheData {
    case let entity as CacheEntity:
      return try Self(entity: entity)

    case let key as CacheKey:
      return try Self(entity: transaction.entity(withKey: key)!)

    case let data as [String: Any]:
      return try Self(entity: transaction.entity(withData: data))

    case let interface as CacheInterface:
      return try Self(interface: interface)

    default:
      throw CacheReadError.Reason.unrecognizedCacheData(cacheData, forType: Self.self) // TODO
    }
  }

  public func set(value: Cacheable?, forField field: String) throws {
    try entity.set(value: value, forField: field)
  }

  open func propertyType(forField field: String) -> Cacheable.Type? {
    return nil
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
