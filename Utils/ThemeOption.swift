//
//  ThemeOption.swift
//  Maply
//
//  Created by Wilder Moreno on 26/04/26.
//

import SwiftUI

enum ThemeOption: String, CaseIterable, Identifiable {
    case system
    case light
    case dark
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .system:
            return "Sistema"
        case .light:
            return "Claro"
        case .dark:
            return "Oscuro"
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
