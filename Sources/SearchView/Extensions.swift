//
//  Extensions.swift
//  SearchableView
//
//  Created by Abdullah Alhaider on 18/03/2020.
//  Copyright © 2020 Abdullah Alhaider. All rights reserved.
//

import SwiftUI

// MARK:- ResignKeyboardOnDragGesture
@available(iOS 13.0, *)
public struct ResignKeyboardOnDragGesture: ViewModifier {
    public var gesture = DragGesture().onChanged { _ in
        UIApplication.endEditing(true)
    }
    
    public func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

// MARK:- View
@available(iOS 13.0, *)
public extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}

// MARK:- UIApplication
public extension UIApplication {
    static func endEditing(_ force: Bool) {
        shared
            .windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}
