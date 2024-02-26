//
//  IdentifiableStringConvertible.swift
//  SearchView
//
//  Created by Abdullah Alhaider on 26/02/2024.
//

import Foundation

/// Protocol for identifiable objects that can be represented as a string.
public protocol IdentifiableStringConvertible: Identifiable {
    var idStringValue: String { get }
}
