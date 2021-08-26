public protocol AnyCacheObject: AnyObject, Cacheable {
  var _transaction: CacheTransaction { get }
  var data: [String: Any] { get }

  func set<T: Cacheable>(value: T?, forField field: CacheField<T>) throws
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
  open class var __metadata: Metadata { Metadata.Empty }

  final var __typename: String { data["__typename"] as! String } // TODO: delete?

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

    case let interface as CacheInterface:
      guard let entity = interface.entity as? Self else {
        throw CacheError.Reason.unrecognizedCacheData(cacheData, forType: Self.self)
      }
      return entity

    case let key as CacheKey:
      return transaction.entity(withKey: key) as! Self

    case let data as [String: Any]:
      return transaction.entity(withData: data) as! Self

    default:
      throw CacheError.Reason.unrecognizedCacheData(cacheData, forType: Self.self)
    }
  }

  public final func set<T: Cacheable>(value: T?, forField field: CacheField<T>) throws {
    let fieldName = field.field.description

    guard let value = value else {
      data[fieldName] = nil
      return
    }

    switch T.self {
    case is AnyCacheObject.Type:
      do {
        // Check for field covariance
        switch Self.__metadata.fieldTypeIfCovariant(forField: fieldName) ?? T.self {
        case let interfaceType as CacheInterface.Type:
          data[fieldName] = try interfaceType.value(with: value, in: _transaction)

        case let entityType as CacheEntity.Type:
          data[fieldName] = try entityType.value(with: value, in: _transaction)

        default: break // TODO: throw error
        }

      } catch let error as CacheError.Reason {
        switch error {
        case let .invalidEntityType(_, forInterface: fieldType as AnyCacheObject.Type),
             let .unrecognizedCacheData(_, forType: fieldType as AnyCacheObject.Type):
          throw CacheError.Reason.invalidValue(value, forCovariantFieldOfType: fieldType)

        default: throw error
        }
      }

//    case is ScalarType.Type:
//    break
//    case is CustomScalarType.Type:
//    break
//    case is GraphQLEnum.Type:
//    break
    default: break
    }
  }
}

extension CacheEntity {
  public struct Metadata {
    private let implementedInterfaces: [CacheInterface.Type]?
    private let covariantFields: [String: Cacheable.Type]?

    fileprivate static let Empty = Metadata()

    public init(implements: [CacheInterface.Type]? = nil,
                covariantFields: [String: Cacheable.Type]? = nil) {
      self.implementedInterfaces = implements
      self.covariantFields = covariantFields
    }

    func fieldTypeIfCovariant(forField field: String) -> Cacheable.Type? {
      covariantFields?[field]
    }

    func implements(_ interface: CacheInterface.Type) -> Bool {
      implementedInterfaces?.contains(where: { $0 == interface }) ?? false
    }
  }
}

enum MockError: Error {
  case mock // TODO
}

open class CacheInterface: AnyCacheObject, Cacheable {

  final let entity: CacheEntity
  final var underlyingType: CacheEntity.Type { Swift.type(of: entity) } // TODO: Delete?

  public static var fields: [String : Cacheable.Type] { [:] }

  public final var _transaction: CacheTransaction { entity._transaction }
  public final var data: [String: Any] { entity.data }

  public required init(_ entity: CacheEntity) throws {
    let entityType = type(of: entity)    
    guard entityType.__metadata.implements(Self.self) else {
      throw CacheError.Reason.invalidEntityType(entityType, forInterface: Self.self)
    }

    self.entity = entity
  }

  public required convenience init(_ interface: CacheInterface) throws {
    try self.init(interface.entity)
  }

  public static func value(
    with cacheData: Any,
    in transaction: CacheTransaction
  ) throws -> Self {
    switch cacheData {
    case let entity as CacheEntity:
      return try Self(entity)

    case let key as CacheKey:
      return try Self(transaction.entity(withKey: key)!)

    case let data as [String: Any]:
      return try Self(transaction.entity(withData: data))

    case let interface as CacheInterface:
      return try Self(interface)

    default:
      throw CacheError.Reason.unrecognizedCacheData(cacheData, forType: Self.self) // TODO
    }
  }

  public final func set<T: Cacheable>(value: T?, forField field: CacheField<T>) throws {
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

/// Represents a key that references a record in the cache.
public struct CacheKey: Hashable {
  public let key: String

  public init(_ key: String) {
    self.key = key
  }
}
