//
//  ResponseDataProtocols.swift
//  CodegenProposalFramework
//
//  Created by Anthony Miller on 2/16/21.
//

// MARK: - Fragment

/// A protocol representing a fragment that a `ResponseObject` object may be converted to.
///
/// A `ResponseObject` that conforms to `HasFragments` can be converted to
/// any `Fragment` included in it's `Fragments` object via its `fragments` property.
///
/// - SeeAlso: `HasFragments`, `ToFragments`
protocol Fragment: FieldData { }

// MARK: - HasFragments

/// A protocol that a `ResponseObject` that contains fragments should conform to.
protocol HasFragments: FieldData {

  /// A type representing all of the fragments contained on the `ResponseObject`.
  ///
  /// This type should always be a generic `ToFragments` object.
  associatedtype Fragments: FieldData
}

extension HasFragments {
  /// A `FieldData` object that contains accessors for all of the fragments
  /// the object can be converted to.
  var fragments: Fragments { Fragments(data: data) }
}
