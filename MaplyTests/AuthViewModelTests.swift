//
//  AuthViewModelTests.swift
//  MaplyTests
//
//  Created by Wilder Moreno on 29/04/26.
//

import XCTest
@testable import Maply

final class AuthViewModelTests: XCTestCase {
    
    func testIsFormValidReturnsFalseWhenEmailAndPasswordAreEmpty() {
        let viewModel = AuthViewModel()
        
        viewModel.email = ""
        viewModel.password = ""
        
        XCTAssertFalse(viewModel.isFormValid)
    }
    
    func testIsFormValidReturnsTrueWhenEmailAndPasswordHaveValues() {
        let viewModel = AuthViewModel()
        
        viewModel.email = "wilder@maply.com"
        viewModel.password = "123456"
        
        XCTAssertTrue(viewModel.isFormValid)
    }
}
