//
//  CountryView.swift
//  SearchableView
//
//  Created by Abdullah Alhaider on 18/03/2020.
//  Copyright © 2020 Abdullah Alhaider. All rights reserved.
//

import SwiftUI

struct CountryView: View {
    @Binding var isPresented: Bool
    @Binding var selectedCountry: Country
    @State private var searchText = ""
    var allCountrys = Country.allCountrys

    var filteredCountries: [Country] {
        allCountrys.filter { // Don't use `Country.allCountries` directly as it will affect the proformence
            // filtering logic..
            $0.name?.range(of: searchText, options: .caseInsensitive) != nil || searchText == ""
        }
    }
    
    var body: some View {
        NavigationView {
            SearchView(searchText: $searchText) {
                List(self.filteredCountries) { country in
                    CountryListCellView(country: country)
                        .onTapGesture {
                            self.updateWith(selected: country)
                    }
                }
            }
            .navigationBarTitle(Text("Search"))
            .resignKeyboardOnDragGesture()
        }
    }

    private func updateWith(selected country: Country) {
        // Saving country code for new app open -> better UX
        UserDefaults.setValue(country.code, forKey: .lastSelectedCountry)
        // Updating selectedCountry with new country
        selectedCountry = country
        // Dismissing the sheet
        isPresented.toggle()
    }
}
