//
//  SearchView.swift
//  SearchableView
//
//  Created by Abdullah Alhaider on 18/03/2020.
//  Copyright © 2020 Abdullah Alhaider. All rights reserved.
//

import SwiftUI

/// Native SwiftUI Search view
@available(iOS 13.0, *)
public struct SearchView<Content>: View where Content: View {
    
    @Binding var searchText: String
    let content: () -> Content
    
    @State private var showCancelButton: Bool = false
    
    public init(searchText: Binding<String>, @ViewBuilder content: @escaping () -> Content) {
        self._searchText = searchText
        self.content = content
    }
    
    public var body: some View {
        VStack {
            // Search View
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    
                    TextField("Search", text: $searchText, onEditingChanged: { isEditing in
                        self.showCancelButton = true
                    }, onCommit: {
                        // You can add a callback same as `onCancel`
                        print("onCommit")
                    }).foregroundColor(.primary)
                    
                    Button(action: {
                        self.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                    }
                }
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                .foregroundColor(.secondary)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10.0)
                
                if showCancelButton  {
                    Button("Cancel", action: cancel)
                }
            }
            .padding(showCancelButton ? [.top, .leading, .trailing] : .horizontal)
            .navigationBarHidden(showCancelButton)
            .animation(.easeInOut)
            
            // View builder content
            content()
        }
    }
    
    private func cancel() {
        UIApplication.endEditing(true) // this must be placed before the other commands here
        searchText = ""
        showCancelButton = false
    }
}

@available(iOS 13.0.0, *)
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(searchText: .constant("AA")) {
            Text("Hey")
        }
    }
}
