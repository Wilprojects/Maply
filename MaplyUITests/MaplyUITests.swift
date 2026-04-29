//
//  MaplyUITests.swift
//  MaplyUITests
//
//  Created by Wilder Moreno on 18/04/26.
//

import XCTest

final class MaplyUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLoginFlowNavigatesToHomeScreen() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--uitesting-reset-session")
        app.launch()

        let emailTextField = app.textFields["login_email_textfield"]
        XCTAssertTrue(emailTextField.waitForExistence(timeout: 5))

        emailTextField.tap()
        emailTextField.typeText("wilder@maply.com")

        let securePasswordField = app.secureTextFields["login_password_textfield"]
        let plainPasswordField = app.textFields["login_password_textfield"]

        if securePasswordField.waitForExistence(timeout: 2) {
            securePasswordField.tap()
            securePasswordField.typeText("123456")
        } else {
            XCTAssertTrue(plainPasswordField.waitForExistence(timeout: 2))
            plainPasswordField.tap()
            plainPasswordField.typeText("123456")
        }

        let loginButton = app.buttons["login_submit_button"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 3))
        loginButton.tap()

        let homeTitle = app.staticTexts["map_home_title"]
        XCTAssertTrue(homeTitle.waitForExistence(timeout: 8))
    }
}
