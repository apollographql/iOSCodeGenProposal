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
struct HeightInMeters: SelectionSet, Fragment {
  static var __type: SelectionSetType { .Interface(.Animal) }
  let data: ResponseData

  var height: Height  { data["height"] }

  struct Height: SelectionSet {
    static var __type: SelectionSetType { .ConcreteType(.Height) }
    let data: ResponseData

    var meters: Int { data["meters"] }
  }
}
