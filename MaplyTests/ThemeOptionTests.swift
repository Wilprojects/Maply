//
//  ThemeOptionTests.swift
//  MaplyTests
//
//  Created by Wilder Moreno on 29/04/26.
//

import XCTest
import SwiftUI
@testable import Maply

final class ThemeOptionTests: XCTestCase {
    
    func testSystemThemeReturnsNilColorScheme() {
        let theme = ThemeOption.system
        
        XCTAssertNil(theme.colorScheme)
    }
    
    func testDarkThemeReturnsDarkColorScheme() {
        let theme = ThemeOption.dark
        
        XCTAssertEqual(theme.colorScheme, .dark)
    }
}
