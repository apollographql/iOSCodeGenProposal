//
//  HeightInMeters.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/16/21.
//

import Foundation

/// A response data object for a `HeightInMeters` fragment
///
/// ```
/// fragment HeightInMeters on Animal {
///   height {
///     meters
///   }
/// }
/// ```
final class HeightInMeters: RootResponseObjectBase<HeightInMeters.Fields, Void>, Fragment {
  final class Fields: FieldData {
    @Field("height") final var height: Height
  }

//  convenience init(height: Height) {
//    self.init(fields: Fields(height: height))
//  }

  final class Height: RootResponseObjectBase<Height.Fields, Void> {
    final class Fields: FieldData {
      @Field("meters") final var meters: Int
    }

//    convenience init(meters: Int) {
//      self.init(fields: Fields(meters: meters))
//    }
  }  
}

/// A generic type condition for a `HeightInMeters` fragment
///
/// ```
/// fragment HeightInMeters on Animal {
///   height {
///     meters
///   }
/// }
/// ```
class AsHeightInMeters<Parent: ResponseObject>: FragmentTypeConditionBase<HeightInMeters, Parent> {
  final class Fragments: ToFragments<Parent, ResponseData> {
    private(set) lazy var heightInMeters = HeightInMeters(data: self.data)
  }
}
