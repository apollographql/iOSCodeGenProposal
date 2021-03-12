enum SelectionSetType<S: GraphQLSchema> {
  case ObjectType(S.ObjectType)
  case Interface(S.Interface)
}

protocol SelectionSet: ResponseObject, Equatable {

  associatedtype Schema: GraphQLSchema

  /// The GraphQL type for the `SelectionSet`.
  ///
  /// This may be a concrete type (`ConcreteType`) or an abstract type (`Interface`).
  static var __parentType: SelectionSetType<Schema> { get }
}

extension SelectionSet {

  var __objectType: Schema.ObjectType? { Schema.ObjectType(rawValue: __typename) }

  var __typename: String { data["__typename"] }

  func asType<T: SelectionSet>() -> T? where T.Schema == Schema {
    guard let __objectType = __objectType else { return nil } // TODO: Unit Test
    switch T.__parentType {
    case .ObjectType(let type):
      guard __objectType == type else { return nil }
    case .Interface(let interface):
      guard __objectType.implements(interface) else { return nil }
    }

    return T.init(data: data)
  }
}

func ==<T: SelectionSet>(lhs: T, rhs: T) -> Bool {
  return true // TODO: Unit test & implement this
}

