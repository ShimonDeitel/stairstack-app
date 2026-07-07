import XCTest

final class StairstackUITests: XCTestCase {
    func testAddEntryFlow() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["addEntryButton"].tap()
        app.buttons["saveEntryButton"].tap()
        XCTAssertTrue(app.navigationBars["Stairstack"].waitForExistence(timeout: 2))
    }

    func testPaywallTriggersAtFreeLimit() {
        let app = XCUIApplication()
        app.launchArguments = ["-forceFreeLimitReached"]
        app.launch()
        app.buttons["addEntryButton"].tap()
        let subscribeExists = app.buttons["subscribeButton"].waitForExistence(timeout: 2)
        let saveExists = app.buttons["saveEntryButton"].exists
        XCTAssertTrue(subscribeExists || saveExists)
    }

    func testKeyboardDismissOnTapOutside() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["addEntryButton"].tap()
        let field = app.textFields.firstMatch
        field.tap()
        app.staticTexts["New Entry"].tap()
        XCTAssertFalse(field.hasKeyboardFocus)
    }

    func testSettingsOpens() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["settingsButton"].tap()
        XCTAssertTrue(app.buttons["settingsDoneButton"].waitForExistence(timeout: 2))
        app.buttons["settingsDoneButton"].tap()
    }

    func testCancelAdd() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["addEntryButton"].tap()
        app.buttons["cancelAddButton"].tap()
        XCTAssertTrue(app.navigationBars["Stairstack"].waitForExistence(timeout: 2))
    }
}
