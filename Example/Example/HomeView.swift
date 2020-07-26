//
//  HomeView.swift
//  SearchableView
//
//  Created by Abdullah Alhaider on 18/03/2020.
//  Copyright © 2020 Abdullah Alhaider. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showSelectCountry = false
    @State private var selectedCountry = Country.currentCountry ?? Country.allCountrys[0]
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        CountryListCellView(country: selectedCountry)
                        Color.black.opacity(0.4)
                            .frame(width: 1)
                            .cornerRadius(0.5)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                        Button("Change") { self.showSelectCountry.toggle() }
                    }
                    .sheet(isPresented: $showSelectCountry) {
                        CountryView(
                            isPresented: self.$showSelectCountry,
                            selectedCountry: self.$selectedCountry
                        )
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle("Home")
        }
    }
}

struct CountryListCellView: View {
    let country: Country
    
    var body: some View {
        HStack {
            Text(country.flag ?? "🤒")
                .font(.title)
            Text(country.name ?? "")
            Spacer()
            Text("📞 \(country.dialCode ?? "")")
                .font(.body)
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
