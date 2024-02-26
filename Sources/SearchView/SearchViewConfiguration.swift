//
//  SearchViewConfiguration.swift
//  SearchView
//
//  Created by Abdullah Alhaider on 26/02/2024.
//

import Foundation

/// Configuration struct for customizing the search view's text elements.
public struct SearchViewConfiguration {
    /// Text to display when the search field is empty.
    let emptySearchText: String
    /// Header text for the recent searches section.
    let recentSearchesHeaderText: String
    /// Text for the button that clears recent searches.
    let clearButtonText: String
    /// Text to display when no search results are found.
    let noResultsText: String
    /// Prompt text for the search field.
    let searchPrompt: String
    /// Maximum number of recent searches to save and display.
    let recentSavedSearchesCount: Int

    /// Initializes a new `SearchViewConfiguration` with optional custom values.
    /// - Parameters:
    ///   - emptySearchText: Text to display when the search field is empty. Defaults to "Start searching for items now!".
    ///   - recentSearchesHeaderText: Header text for the recent searches section. Defaults to "Recent Searches".
    ///   - clearButtonText: Text for the button that clears recent searches. Defaults to "Clear".
    ///   - noResultsText: Text to display when no search results are found. Defaults to "No results found.".
    ///   - searchPrompt: Prompt text for the search field. Defaults to "Search".
    ///   - recentSavedSearchesCount: Maximum number of recent searches to save and display. Defaults to 10.
    public init(
        emptySearchText: String = "Start searching for items now!",
        recentSearchesHeaderText: String = "Recent Searches",
        clearButtonText: String = "Clear",
        noResultsText: String = "No results found.",
        searchPrompt: String = "Search",
        recentSavedSearchesCount: Int = 10
    ) {
        self.emptySearchText = emptySearchText
        self.recentSearchesHeaderText = recentSearchesHeaderText
        self.clearButtonText = clearButtonText
        self.noResultsText = noResultsText
        self.searchPrompt = searchPrompt
        self.recentSavedSearchesCount = recentSavedSearchesCount
    }
}
