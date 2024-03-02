//
//  SearchView.swift
//  SearchView
//
//  Created by Abdullah Alhaider on 26/02/2024.
//

import SwiftUI

/// Generic search view for displaying search results and handling recent searches.
public struct SearchView<Item, Content, Value>: View where Item: Searchable, Content: View, Value: Hashable {
    /// Binding to the current search query input by the user.
    @Binding var searchQuery: String
    /// State to track if the search bar is focused.
    @State private var isSearchBarFocused = false
    /// State to hold the IDs of recent searches, loaded from UserDefaults.
    @State private var recentSearchIDs: [String] = []
    /// Data list to be searched.
    let items: [Item]
    /// KeyPaths of the data list items that can be searched.
    let searchableProperties: [KeyPath<Item, Value>]
    /// Closure that defines how to display each item in the search results.
    let content: (Item, String) -> Content
    /// Configuration for customizing text elements in the view.
    let configuration: SearchViewConfiguration
    /// Key to store the recent searches
    let storeId: String
    
    /// Initializes a new search view with the provided parameters.
    /// - Parameters:
    ///   - items: The array of data items that the search will be performed on.
    ///   - searchableProperties: An array of key paths for the `Item` elements. These key paths
    ///     indicate the properties of the data items that should be considered during the search.
    ///   - searchQuery: A binding to the current search query input by the user. Changes to this value
    ///     will trigger the search functionality.
    ///   - configuration: Configuration for customizing text elements in the view. This allows for
    ///     customization of various UI text elements like prompts, empty state messages, etc.
    ///     Defaults to a standard configuration if not specified.
    ///   - storeId: An optional string to specify the key under which recent searches will be stored
    ///     in UserDefaults. If not provided, a default key is generated based on the `Item` type.
    ///     This allows for separate recent search lists for different types of data.
    ///   - content: A closure that defines how to display each item in the search results. This closure
    ///     provides a way to customize the appearance and behavior of the list items.
    ///
    /// Example Usage:
    /// ```
    /// struct MyDataItem: Searchable {
    ///     var id: UUID
    ///     var name: String
    /// }
    ///
    /// @State private var searchQuery: String = ""
    ///
    /// let dataList = [
    ///     MyDataItem(id: UUID(), name: "Item 1"),
    ///     MyDataItem(id: UUID(), name: "Item 2")
    /// ]
    ///
    /// SearchView(items: dataList,
    ///            searchableProperties: [\MyDataItem.name],
    ///            searchQuery: $searchQuery
    ///          ) { item, query in
    ///     Text(item.name)
    /// }
    /// ```
    /// This simple example creates a `SearchView` for a custom data type `MyDataItem` that searches
    /// the name property of each item.
    public init(
        items: [Item],
        searchableProperties: [KeyPath<Item, Value>],
        searchQuery: Binding<String>,
        configuration: SearchViewConfiguration = SearchViewConfiguration(),
        storeId: String? = nil,
        @ViewBuilder content: @escaping (Item, String) -> Content
    ) {
        self.items = items
        self.searchableProperties = searchableProperties
        self._searchQuery = searchQuery
        self.content = content
        self.configuration = configuration
        let sid: String = storeId == nil ? ("RecentSearches_" + String(describing: Item.self)) : storeId!
        self.storeId = sid
        self.recentSearchIDs = UserDefaults.standard.stringArray(forKey: sid) ?? []
    }
    
    public var body: some View {
        VStack {
            // Determine view based on search bar focus and query conditions
            if isSearchBarFocused {
                // When search bar is focused but query is either empty or only whitespace
                if searchQuery.isEmpty || searchQuery.allSatisfy({ $0.isWhitespace }) {
                    // Show recent searches if available, otherwise show empty search view
                    if recentSearchIDs.isEmpty {
                        emptySearchView
                    } else {
                        recentSearchesView
                    }
                    // When search bar is focused and the filtered data list is empty
                } else if filteredDataList().isEmpty {
                    noResultsView
                    // Default to showing search results
                } else {
                    searchResultsView
                }
                // Show search results when search bar is not focused
            } else {
                searchResultsView
            }
        }
        .searchable(text: $searchQuery, isPresented: $isSearchBarFocused, prompt: configuration.searchPrompt)
        .onAppear {
            loadRecentSearchIDs()
        }
    }
    
    /// View displayed when there are no search results and the search query is empty.
    private var emptySearchView: some View {
        VStack {
            Text(configuration.emptySearchText)
                .foregroundColor(.gray)
                .italic()
                .padding()
            Spacer()
        }
    }
    
    /// View for displaying a message when no search results are found.
    private var noResultsView: some View {
        VStack {
            Text(configuration.noResultsText)
                .foregroundColor(.gray)
                .padding()
            Spacer()
        }
    }
    
    /// View displaying the list of recent searches.
    private var recentSearchesView: some View {
        List {
            Section {
                ForEach(recentItems()) { item in
                    content(item, "")
                }
            } header: {
                HStack {
                    Text(configuration.recentSearchesHeaderText)
                    Spacer()
                    Button(configuration.clearButtonText, action: clearRecentSearches)
                        .font(.callout)
                }
            }
        }
    }
    
    /// View displaying the search results based on the current query.
    private var searchResultsView: some View {
        List {
            Section {
                ForEach(filteredDataList()) { item in
                    content(item, searchQuery)
                    // https://www.hackingwithswift.com/quick-start/swiftui/how-to-make-two-gestures-recognize-at-the-same-time-using-simultaneousgesture
                        .simultaneousGesture(
                            TapGesture()
                                .onEnded { _ in
                                    if isSearchBarFocused && !searchQuery.isEmpty {
                                        saveRecentSearch(item: item)
                                    }
                                }
                        )
                }
            } header: {
                if isSearchBarFocused && !searchQuery.isEmpty {
                    let resultsCount = filteredDataList().count
                    let headerText = String(format: configuration.foundResultsHeaderText, "\(resultsCount)")
                    Text(headerText)
                }
            }
        }
    }
    
    /// Filters the dataList to find items that match the search query.
    private func recentItems() -> [Item] {
        items.filter { item in
            recentSearchIDs.contains(item.idStringValue)
        }
    }
    
    /// Filters the dataList to find items that match the search query.
    private func filteredDataList() -> [Item] {
        if searchQuery.isEmpty {
            return items
        } else {
            return items.filter { item in
                searchableProperties.contains { keyPath in
                    let value = item[keyPath: keyPath]
                    return "\(value)".localizedCaseInsensitiveContains(searchQuery)
                }
            }
        }
    }
    
    /// Saves the ID of the recently tapped item to UserDefaults.
    private func saveRecentSearch(item: Item) {
        let itemID = item.idStringValue
        if let index = recentSearchIDs.firstIndex(of: itemID) {
            recentSearchIDs.remove(at: index)
        }
        recentSearchIDs.insert(itemID, at: 0)
        if recentSearchIDs.count > configuration.recentSavedSearchesCount {
            recentSearchIDs.removeLast()
        }
        UserDefaults.standard.set(recentSearchIDs, forKey: storeId)
    }
    
    /// Loads the IDs of recent searches from UserDefaults.
    private func loadRecentSearchIDs() {
        recentSearchIDs = UserDefaults.standard.stringArray(forKey: storeId) ?? []
    }
    
    /// Clears all recent search IDs from UserDefaults.
    private func clearRecentSearches() {
        withAnimation {
            recentSearchIDs.removeAll()
        }
        UserDefaults.standard.set(recentSearchIDs, forKey: storeId)
    }
}

