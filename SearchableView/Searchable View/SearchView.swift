//
//  SearchView.swift
//  SearchableView
//
//  Created by Abdullah Alhaider on 18/03/2020.
//  Copyright © 2020 Abdullah Alhaider. All rights reserved.
//

import SwiftUI

/// Native SwiftUI Search view
struct SearchView<Content>: View where Content: View{
    
    @Binding var searchText: String
    let content: () -> Content
    let onCancel: () -> Void?
    
    @State private var showCancelButton: Bool = false
    
    init(searchText: Binding<String>, onCancel: @escaping () -> Void? = {}, @ViewBuilder content: @escaping () -> Content) {
        self._searchText = searchText
        self.content = content
        self.onCancel = onCancel
    }
    
    var body: some View {
        VStack {
            // Search View
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    
                    TextField("Search", text: $searchText, onEditingChanged: { isEditing in
                        self.showCancelButton = true
                    }, onCommit: {
                        // You can add a call back same as `onCancel`
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
                        .foregroundColor(Color(.systemBlue))
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
        onCancel()
    }
}
