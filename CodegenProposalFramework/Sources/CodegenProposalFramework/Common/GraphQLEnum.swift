/// A generic enum that wraps a generated enum from a GraphQL Schema.
///
/// `GraphQLEnum` provides an `__unknown` case that is used when the response returns a value that
/// is not recognized as a valid enum case. This is usually caused by future cases added to the enum
/// on the schema after code generation.
enum GraphQLEnum<T>: CaseIterable, Equatable, RawRepresentable
where T: RawRepresentable & CaseIterable, T.RawValue == String {
  public typealias RawValue = String

  /// A recognized case of the wrapped enum.
  case `case`(T)

  /// An unrecognized value for the enum.
  /// The associated value exposes the raw `String` data from the response.
  case __unknown(String)

  init(_ caseValue: T) {
    self = .case(caseValue)
  }

  init(rawValue: String) {
    guard let caseValue = T(rawValue: rawValue) else {
      self = .__unknown(rawValue)
      return
    }
    self = .case(caseValue)
  }

  /// The underlying enum case. If the value is `__unknown`, this will be `nil`.
  var value: T? {
    switch self {
    case .case(let value): return value
    default: return nil
    }
  }

  var rawValue: String {
    switch self {
    case .case(let value): return value.rawValue
    case .__unknown(let value): return value
    }
  }

  /// A collection of all known values of the wrapped enum.
  /// This collection does not include the `__unknown` case.
  static var allCases: [GraphQLEnum<T>] {
    return T.allCases.map { .case($0) }
  }

  static func ==(lhs: GraphQLEnum<T>, rhs: GraphQLEnum<T>) -> Bool {
    return lhs.rawValue == rhs.rawValue
  }

  static func ==(lhs: GraphQLEnum<T>, rhs: T) -> Bool {
    return lhs.rawValue == rhs.rawValue
  }

  static func !=(lhs: GraphQLEnum<T>, rhs: T) -> Bool {
    return lhs.rawValue != rhs.rawValue
  }
}

func ~=<T>(lhs: T, rhs: GraphQLEnum<T>) -> Bool {
  switch rhs {
  case let .case(rhs) where rhs == lhs: return true
  case let .__unknown(rhsRawValue) where rhsRawValue == lhs.rawValue: return true
  default: return false
  }
}