protocol AnyUnion: AnyCacheObject {
  var entity: CacheEntity { get }
}

// MARK: - UnionType
public protocol UnionType {
  static var possibleTypes: [CacheEntity.Type] { get }
  var entity: CacheEntity { get }

  init?(_ entity: CacheEntity)
}

public enum Union<T: UnionType>: AnyUnion, Equatable {

  case `case`(T)
  case __unknown(CacheEntity)

  init(_ entity: CacheEntity) throws {
    guard let value = T.init(entity) else {
      guard entity.__typename != CacheEntity.UnknownTypeName else {
        self = .__unknown(entity)
        return
      }

      throw CacheError.Reason.invalidEntityType(type(of: entity), forAbstractType: Self.self)
    }

    self = .case(value)
  }

  public static func value(
    with cacheData: Any,
    in transaction: CacheTransaction
  ) throws -> Self {
    guard let entity = entity(with: cacheData, in: transaction) else {
      throw CacheError.Reason.unrecognizedCacheData(cacheData, forType: T.self)
    }

    return try Self(entity)
  }

  private static func entity(
    with cacheData: Any,
    in transaction: CacheTransaction
  ) -> CacheEntity? {
    switch cacheData {
    case let entity as CacheEntity: return entity
    case let interface as CacheInterface: return interface.entity
    case let key as CacheKey: return transaction.entity(withKey: key)
    case let data as [String: Any]: return transaction.entity(withData: data)
    default: return nil
    }
  }

  var value: T? {
    switch self {
    case let .case(value): return value
    default: return nil
    }
  }

  var entity: CacheEntity {
    switch self {
    case let .case(value): return value.entity
    case let .__unknown(entity): return entity
    }
  }

  public var _transaction: CacheTransaction { entity._transaction }
  public var data: [String : Any] { entity.data }

  public func set<T: Cacheable>(value: T?, forField field: CacheField<T>) throws {
    try entity.set(value: value, forField: field)
  }
}

// MARK: Union Equatable
extension Union {
  public static func ==(lhs: Union<T>, rhs: Union<T>) -> Bool {
    return lhs.entity === rhs.entity
  }

  public static func ==(lhs: Union<T>, rhs: T) -> Bool {
    return lhs.entity === rhs.entity
  }

  public static func ==(lhs: Union<T>, rhs: CacheEntity) -> Bool {
    return lhs.entity === rhs
  }

  public static func !=(lhs: Union<T>, rhs: Union<T>) -> Bool {
    return lhs.entity !== rhs.entity
  }

  public static func !=(lhs: Union<T>, rhs: T) -> Bool {
    return lhs.entity !== rhs.entity
  }

  public static func !=(lhs: Union<T>, rhs: CacheEntity) -> Bool {
    return lhs.entity !== rhs
  }
}

// MARK: Optional<Union<T>> Equatable

public func ==<T: UnionType>(lhs: Union<T>?, rhs: Union<T>) -> Bool {
  return lhs?.entity === rhs.entity
}

public func ==<T: UnionType>(lhs: Union<T>?, rhs: T) -> Bool {
  return lhs?.entity === rhs.entity
}

public func ==<T: UnionType>(lhs: Union<T>?, rhs: CacheEntity) -> Bool {
  return lhs?.entity === rhs
}

public func !=<T: UnionType>(lhs: Union<T>?, rhs: Union<T>) -> Bool {
  return lhs?.entity !== rhs.entity
}

public func !=<T: UnionType>(lhs: Union<T>?, rhs: T) -> Bool {
  return lhs?.entity !== rhs.entity
}

public func !=<T: UnionType>(lhs: Union<T>?, rhs: CacheEntity) -> Bool {
  return lhs?.entity !== rhs
}

// MARK: Union Pattern Matching Helpers
extension Union {
  public static func ~=(lhs: T, rhs: Union<T>) -> Bool {
    switch rhs {
    case let .case(rhs) where rhs.entity === lhs.entity: return true
    case let .__unknown(rhsEntity) where rhsEntity === lhs.entity: return true
    default: return false
    }
  }
}

// MARK: UnionType Equatable
extension UnionType where Self: Equatable {
  public static func ==(lhs: Self, rhs: Self) -> Bool {
    lhs.entity === rhs.entity
  }

  public static func ==(lhs: Self, rhs: CacheEntity) -> Bool {
    lhs.entity === rhs
  }

  public static func !=(lhs: Self, rhs: Self) -> Bool {
    lhs.entity !== rhs.entity
  }

  public static func !=(lhs: Self, rhs: CacheEntity) -> Bool {
    lhs.entity !== rhs
  }
}

// MARK: Optional<UnionType> Equatable

public func ==<T: UnionType>(lhs: T?, rhs: T) -> Bool {
  return lhs?.entity === rhs.entity
}

public func !=<T: UnionType>(lhs: T?, rhs: T) -> Bool {
  return lhs?.entity !== rhs.entity
}

public func ==<T: UnionType>(lhs: T?, rhs: CacheEntity) -> Bool {
  return lhs?.entity === rhs
}

public func !=<T: UnionType>(lhs: T?, rhs: CacheEntity) -> Bool {
  return lhs?.entity !== rhs
}
