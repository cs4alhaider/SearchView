//
//  SaveRecentSearchModifier.swift
//  SearchView
//
//  Created by Abdullah Alhaider on 26/02/2024.
//

import SwiftUI

/// Defines a ViewModifier to encapsulate the logic for saving a recent search when a view is tapped.
/// This approach centralizes the tap handling logic for saving searches, making it reusable across different views.
public struct SaveRecentSearchModifier<DataSource: Searchable>: ViewModifier {
    /// The specific item of the data source to be saved upon tapping.
    var item: DataSource
    /// The action to be executed to save the item. This closure allows for custom save logic to be injected.
    var saveAction: (DataSource) -> Void

    /// Modifies the content view to include a tap gesture that triggers the save action.
    /// Using a ViewModifier allows us to abstract and reuse the tap gesture logic across multiple views,
    /// ensuring consistency in behavior and reducing code duplication.
    public func body(content: Content) -> some View {
        content.onTapGesture {
            /// Executes the save action when the content is tapped.
            /// This encapsulation allows for any type of view to be enhanced with the ability to save a recent search
            /// without altering the original view's code, promoting a clean and modular design.
            saveAction(item)
        }
    }
}

/// Extends View to include a convenience method for applying the SaveRecentSearchModifier.
public extension View {
    /// Provides a fluent interface to apply the SaveRecentSearchModifier to any View.
    /// This extension method simplifies the application of saving functionality to views,
    /// making the code more readable and easier to maintain.
    func onSaveRecentSearch<DataSource: Searchable>(item: DataSource, action: @escaping (DataSource) -> Void) -> some View {
        /// Applies the SaveRecentSearchModifier with the provided item and save action.
        /// This method abstracts away the details of applying the modifier,
        /// allowing developers to easily add save functionality with minimal boilerplate.
        modifier(SaveRecentSearchModifier(item: item, saveAction: action))
    }
}
