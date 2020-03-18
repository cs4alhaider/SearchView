//
//  Extensions.swift
//  SearchableView
//
//  Created by Abdullah Alhaider on 18/03/2020.
//  Copyright © 2020 Abdullah Alhaider. All rights reserved.
//

import SwiftUI
import SFSafeSymbols

// MARK:- ResignKeyboardOnDragGesture
struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged { _ in
        UIApplication.endEditing(true)
    }
    
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

// MARK:- View
extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}

// MARK:- UIApplication
extension UIApplication {
    static func endEditing(_ force: Bool) {
        shared
            .windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

// MARK:- Bundle
extension Bundle {
    
    /// Decode an exesting json file
    ///
    /// ```
    /// let model = Bundle.main.decode([Model].self, from: "modelss.json")
    /// ```
    ///
    /// - Parameters:
    ///   - type: Decodable object
    ///   - file: file name or uel
    /// - Returns: decoded object
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in app bundle.")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) in app bundle.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from app bundle.")
        }
        return loaded
    }
}

// MARK:- Image
extension Image {
    init(sf: SFSymbol) {
        self = Image(systemSymbol: sf)
    }
}

// MARK:- UserDefaults
extension UserDefaults {
    
    static func value(forKey key: Keys) -> Any? {
        standard.value(forKey: key.rawValue)
    }
    
    static func setValue(_ value: Any?, forKey key: Keys) {
        standard.set(value, forKey: key.rawValue)
    }
    
    enum Keys: String {
        case lastSelectedCountry = "net.alhaider.SearchableText_lastSelectedCountry"
    }
}
