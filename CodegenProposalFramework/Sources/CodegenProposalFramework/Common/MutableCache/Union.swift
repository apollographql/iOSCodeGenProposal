protocol AnyUnion: Cacheable {}
extension Union: AnyUnion {}

public protocol UnionType: Equatable {
  var entity: CacheEntity { get }

  init?(_ entity: CacheEntity)
}

public func ==<T: UnionType>(lhs: T, rhs: T) -> Bool {
  lhs.entity === rhs.entity
}

public enum Union<T: UnionType>: Cacheable, Equatable {

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
    guard let entity = cacheData as? CacheEntity else {
      throw CacheError.Reason.unrecognizedCacheData(cacheData, forType: T.self)
    }

    return try Self(entity)
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

}

// MARK: Equatable
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

  public static func !=(lhs: Union<T>, rhs: T) -> Bool {
    return lhs.entity !== rhs.entity
  }

  public static func !=(lhs: Union<T>, rhs: CacheEntity) -> Bool {
    return lhs.entity !== rhs
  }
}

// MARK: Pattern Matching Helpers

extension Union {
  public static func ~=(lhs: T, rhs: Union<T>) -> Bool {
    switch rhs {
    case let .case(rhs) where rhs == lhs: return true
    case let .__unknown(rhsEntity) where rhsEntity === lhs.entity: return true
    default: return false
    }
  }
}
