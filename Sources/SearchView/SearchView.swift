//
//  SearchView.swift
//  SearchView
//
//  Created by Abdullah Alhaider on 26/02/2024.
//

import SwiftUI

/// Generic search view for displaying search results and handling recent searches.
public struct SearchView<DataSource, Content, Value>: View where DataSource: Hashable & IdentifiableStringConvertible, Content: View, Value: Hashable {
    /// Binding to the current search query input by the user.
    @Binding var searchQuery: String
    /// State to track if the search bar is focused.
    @State private var isSearchBarFocused = false
    /// State to hold the IDs of recent searches, loaded from UserDefaults.
    @State private var recentSearchIDs: [String] = UserDefaults.standard.stringArray(forKey: "RecentSearches") ?? []
    /// Data list to be searched.
    let dataList: [DataSource]
    /// KeyPaths of the data list items that can be searched.
    let searchableKeyPaths: [KeyPath<DataSource, Value>]
    /// Closure that defines how to display each item in the search results.
    let content: (DataSource, String) -> Content
    /// Configuration for customizing text elements in the view.
    let configuration: SearchViewConfiguration
    
    /// Initializes a new search view with the provided parameters.
    public init(
        dataList: [DataSource],
        searchableKeyPaths: [KeyPath<DataSource, Value>],
        searchQuery: Binding<String>,
        configuration: SearchViewConfiguration = SearchViewConfiguration(),
        @ViewBuilder content: @escaping (DataSource, String) -> Content) {
        self.dataList = dataList
        self.searchableKeyPaths = searchableKeyPaths
        self._searchQuery = searchQuery
        self.content = content
        self.configuration = configuration
    }
    
    public var body: some View {
        VStack {
            if isSearchBarFocused && searchQuery.isEmpty {
                if recentSearchIDs.isEmpty {
                    emptySearchView
                } else {
                    recentSearchesView
                }
            } else if isSearchBarFocused && filteredDataList().isEmpty {
                // New view for when there are no results for the current search query.
                noResultsView
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
            ForEach(filteredDataList()) { item in
                content(item, searchQuery)
                    .onTapGesture {
                        if isSearchBarFocused {
                            saveRecentSearch(item: item)
                        }
                    }
            }
        }
    }
    
    /// Filters the dataList to find items that match the search query.
    private func recentItems() -> [DataSource] {
        dataList.filter { item in
            recentSearchIDs.contains(item.idStringValue)
        }
    }
    
    /// Filters the dataList to find items that match the search query.
    private func filteredDataList() -> [DataSource] {
        if searchQuery.isEmpty {
            return dataList
        } else {
            return dataList.filter { item in
                searchableKeyPaths.contains { keyPath in
                    let value = item[keyPath: keyPath]
                    return "\(value)".localizedCaseInsensitiveContains(searchQuery)
                }
            }
        }
    }
    
    /// Saves the ID of the recently tapped item to UserDefaults.
    private func saveRecentSearch(item: DataSource) {
        let itemID = item.idStringValue
        if let index = recentSearchIDs.firstIndex(of: itemID) {
            recentSearchIDs.remove(at: index)
        }
        recentSearchIDs.insert(itemID, at: 0)
        if recentSearchIDs.count > configuration.recentSavedSearchesCount {
            recentSearchIDs.removeLast()
        }
        UserDefaults.standard.set(recentSearchIDs, forKey: "RecentSearches")
    }
    
    /// Loads the IDs of recent searches from UserDefaults.
    private func loadRecentSearchIDs() {
        recentSearchIDs = UserDefaults.standard.stringArray(forKey: "RecentSearches") ?? []
    }
    
    /// Clears all recent search IDs from UserDefaults.
    private func clearRecentSearches() {
        withAnimation {
            recentSearchIDs.removeAll()
        }
        UserDefaults.standard.set(recentSearchIDs, forKey: "RecentSearches")
    }
}
