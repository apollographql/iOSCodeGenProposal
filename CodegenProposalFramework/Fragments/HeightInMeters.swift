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
final class HeightInMeters: ResponseObjectBase<HeightInMeters.Fields>, Fragment {
  final class Fields: FieldData {
    @Field("height") final var height: Height
  }

  final class Height: ResponseObjectBase<Height.Fields> {
    final class Fields: FieldData {
      @Field("meters") final var meters: Int
    }
  }
}
