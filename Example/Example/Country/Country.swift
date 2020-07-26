//
//  Country.swift
//  SearchableView
//
//  Created by Abdullah Alhaider on 18/03/2020.
//  Copyright © 2020 Abdullah Alhaider. All rights reserved.
//

import Foundation

struct Country: Codable, Identifiable, Equatable {
    let id = UUID()
    let name: String?
    let dialCode: String?
    let code: String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case dialCode = "dial_code"
        case code = "code"
    }
    
    /// Emoji flag from country code e.g. "SA"
    var flag: String? {
        code?
            .unicodeScalars
            .map({ 127397 + $0.value })
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
    
    /// Extracting all countrys from countryCodes.json file
    static var allCountrys: [Country] {
        Bundle.main.decode([Country].self, from: "countryCodes.json")
    }
    
    /// Checking system current region code
    static var currentCountry: Country? {
        let code = lastSelectedCountryCode ?? Locale.current.regionCode?.uppercased() ?? "SA"
        return allCountrys.first(where: {$0.code == code})
    }
    
    private static var lastSelectedCountryCode: String? {
        UserDefaults.value(forKey: .lastSelectedCountry) as? String
    }
}
