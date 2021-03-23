@testable import CodegenProposalFramework

struct ClassroomPetsQuery {
  let data: ResponseData

  struct ResponseData: SelectionSet {
    static var __parentType: SelectionSetType<AnimalSchema> { .ObjectType(.Query) }
    let data: ResponseDict

    var classroomPets: [ClassroomPet] { data["classroomPets"] }

    struct ClassroomPet: DirectFragment {
      let fragment: ClassroomPetDetails

      struct Fragments: DirectFragmentBase {
        let fragment: ClassroomPetDetails

        var classroomPetDetails: ClassroomPetDetails { fragment }
      }
    }
//    struct ClassroomPet: SelectionSet, HasFragments {
//      private let fragment: ClassroomPetDetails
//      static var __parentType: SelectionSetType<AnimalSchema> { ClassroomPetDetails.__parentType }
//      var data: ResponseDict { fragment.data }
//
//      init(data: ResponseDict) {
//        fragment = ClassroomPetDetails(data: data)
//      }
//
//      struct Fragments: ResponseObject {
//        private let fragment: ClassroomPetDetails
//        var data: ResponseDict { fragment.data }
//
//        init(data: ResponseDict) {
//          fragment = ClassroomPetDetails(data: data)
//        }
//
//        var classroomPetDetails: ClassroomPetDetails { fragment }
//      }
//    }
  }
}

//protocol FragmentBackedSelectionSet: SelectionSet, HasFragments {
//  associatedtype BackingFragment: Fragment
//
//
//
//}

//struct Fragment<T: SelectionSet>: SelectionSet, HasFragments {
//  private let fragment: T
//  static var __parentType: SelectionSetType<T.Schema> { T.__parentType }
//  var data: ResponseDict { fragment.data }
//
//  init(data: ResponseDict) {
//    fragment = T(data: data)
//  }
//
//
//}

// TODO: @dynamicMemberLookup to inherit all accessors from the Fragment
protocol DirectFragmentBase: ResponseObject {
  associatedtype Fragment: SelectionSet

  var fragment: Fragment { get }

  init(fragment: Fragment)
}

extension DirectFragmentBase {
  var data: ResponseDict { fragment.data }

  init(data: ResponseDict) {
    self.init(fragment: Fragment(data: data))
  }
}

protocol DirectFragment: DirectFragmentBase, HasFragments {}

extension DirectFragment {
  static var __parentType: SelectionSetType<Fragment.Schema> { Fragment.__parentType }
}

//protocol DirectFragmentFragments: DirectFragmentBase, ResponseObject {}

//struct FragmentAccessor<T:SelectionSet>: ResponseObject {
//  private let fragment: T
//  var data: ResponseDict { fragment.data }
//
//  init(data: ResponseDict) {
//    fragment = ClassroomPetDetails(data: data)
//  }
//
//  var classroomPetDetails: ClassroomPetDetails { fragment }
//}
