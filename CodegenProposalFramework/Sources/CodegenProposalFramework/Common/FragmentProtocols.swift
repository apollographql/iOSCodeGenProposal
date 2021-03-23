//
//  ResponseDataProtocols.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/16/21.
//

// MARK: - HasFragments

/// A protocol that a `ResponseObject` that contains fragments should conform to.
protocol HasFragments: SelectionSet {

  /// A type representing all of the fragments contained on the `ResponseObject`.
  associatedtype Fragments: ResponseObject
}

extension HasFragments {
  /// A `FieldData` object that contains accessors for all of the fragments
  /// the object can be converted to.
  var fragments: Fragments { Fragments(data: data) }
}
