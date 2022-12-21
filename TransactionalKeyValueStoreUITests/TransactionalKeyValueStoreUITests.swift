import XCTest

final class TransactionalKeyValueStoreUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = true
        app.launch()
    }

    override func tearDown() {
        app.terminate()
    }

    func testAllComponentsAreRendered(){
        // Given

        // When

        // Then
        XCTAssertTrue(app.staticTexts["SET"].exists)
        XCTAssertTrue(app.staticTexts["GET"].exists)
        XCTAssertTrue(app.staticTexts["DELETE"].exists)
        XCTAssertTrue(app.staticTexts["COUNT"].exists)
        XCTAssertTrue(app.staticTexts["BEGIN"].exists)
        XCTAssertTrue(app.staticTexts["COMMIT"].exists)
        XCTAssertTrue(app.staticTexts["ROLLBACK"].exists)

        XCTAssertTrue(app.textFields["set_key"].exists)
        XCTAssertTrue(app.textFields["set_value"].exists)
        XCTAssertTrue(app.textFields["get_key"].exists)
        XCTAssertTrue(app.textFields["delete_key"].exists)
        XCTAssertTrue(app.textFields["count_value"].exists)
    }

    func testShowConfirmationWhenRunCommit() {
        // Given

        // When
        app.buttons["commit_button"].tap()

        // Then
        XCTAssertTrue(app.buttons["Confirm"].exists)
    }

    func testShowConfirmationWhenRunDelete() {
        // Given
        app.textFields["delete_key"].tap()
        app.textFields["delete_key"].typeText("foo")

        // When
        app.buttons["delete_button"].tap()

        // Then
        XCTAssertTrue(app.buttons["Confirm"].exists)
    }

    func testShowConfirmationWhenRunRollback() {
        // Given

        // When
        app.buttons["rollback_button"].tap()

        // Then
        XCTAssertTrue(app.buttons["Confirm"].exists)
    }

    func testShowErrorIfGetKeyNotSet() {
        // Given
        app.textFields["get_key"].tap()
        app.textFields["get_key"].typeText("foo")

        // When
        app.buttons["get_button"].tap()

        // Then
        XCTAssertTrue(app.alerts["Error"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.alerts["Error"].exists)
    }

    func testCleanUpTextFieldsAfterSetVariable() {
        // Given
        app.textFields["set_key"].tap()
        app.textFields["set_key"].typeText("foo")

        app.textFields["set_value"].tap()
        app.textFields["set_value"].typeText("123")

        // When
        app.buttons["set_button"].tap()

        // Then
        XCTAssertEqual(app.textFields["set_key"].value as? String, "Key")
        XCTAssertEqual(app.textFields["set_value"].value as? String, "Value")
    }

    func testCleanUpTextFieldsAfterGetVariable() {
        // Given
        app.textFields["set_key"].tap()
        app.textFields["set_key"].typeText("foo")

        app.textFields["set_value"].tap()
        app.textFields["set_value"].typeText("123")

        app.buttons["set_button"].tap()

        app.textFields["get_key"].tap()
        app.textFields["get_key"].typeText("foo")

        // When
        app.buttons["get_button"].tap()
        app.buttons["OK"].tap()

        // Then
        XCTAssertEqual(app.textFields["get_key"].value as? String, "Key")
    }

    func testShowOutputForGet() {
        // Given
        app.textFields["set_key"].tap()
        app.textFields["set_key"].typeText("foo")

        app.textFields["set_value"].tap()
        app.textFields["set_value"].typeText("123")

        app.buttons["set_button"].tap()

        app.textFields["get_key"].tap()
        app.textFields["get_key"].typeText("foo")

        // When
        app.buttons["get_button"].tap()

        // Then
        XCTAssertTrue(app.alerts["Process output"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.alerts["Process output"].staticTexts["123"].exists)
    }

    func testShowErrorIfGetVariableNotPresent() {
        // Given
        app.textFields["get_key"].tap()
        app.textFields["get_key"].typeText("foo")

        // When
        app.buttons["get_button"].tap()

        // Then
        XCTAssertTrue(app.alerts["Error"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.alerts["Error"].staticTexts["key not set"].exists)
    }

    func testShowOutputForCount() {
        // Given
        app.textFields["set_key"].tap()
        app.textFields["set_key"].typeText("foo")

        app.textFields["set_value"].tap()
        app.textFields["set_value"].typeText("123")

        app.buttons["set_button"].tap()

        app.textFields["count_value"].tap()
        app.textFields["count_value"].typeText("123")

        // When
        app.buttons["count_button"].tap()

        // Then
        XCTAssertTrue(app.alerts["Process output"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.alerts["Process output"].staticTexts["1"].exists)
    }

    func testCleanUpTextFieldsAfterCountValue() {
        // Given
        app.textFields["set_key"].tap()
        app.textFields["set_key"].typeText("foo")

        app.textFields["set_value"].tap()
        app.textFields["set_value"].typeText("123")

        app.buttons["set_button"].tap()

        app.textFields["count_value"].tap()
        app.textFields["count_value"].typeText("123")

        // When
        app.buttons["count_button"].tap()
        app.buttons["OK"].tap()

        // Then
        XCTAssertEqual(app.textFields["count_value"].value as? String, "Value")
    }

    func testCleanUpTextFieldsAfterDeleteVariable() {
        // Given
        app.textFields["set_key"].tap()
        app.textFields["set_key"].typeText("foo")

        app.textFields["set_value"].tap()
        app.textFields["set_value"].typeText("123")

        app.buttons["set_button"].tap()

        app.textFields["delete_key"].tap()
        app.textFields["delete_key"].typeText("foo")

        // When
        app.buttons["delete_button"].tap()
        app.buttons["Confirm"].tap()

        // Then
        XCTAssertEqual(app.textFields["delete_key"].value as? String, "Key")
    }

    func testShowErrorIfDeleteVariableNotPresent() {
        // Given
        app.textFields["delete_key"].tap()
        app.textFields["delete_key"].typeText("foo")

        // When
        app.buttons["delete_button"].tap()
        app.buttons["Confirm"].tap()

        // Then
        XCTAssertTrue(app.alerts["Error"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.alerts["Error"].staticTexts["key not set"].exists)
    }

    func testShowErrorWhenTryingToCommitNoTransaction() {
        // Given

        // When
        app.buttons["commit_button"].tap()
        app.buttons["Confirm"].tap()

        // Then
        XCTAssertTrue(app.alerts["Error"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.alerts["Error"].staticTexts["no transaction"].exists)
    }

    func testShowErrorWhenTryingToRollbackNoTransaction() {
        // Given

        // When
        app.buttons["rollback_button"].tap()
        app.buttons["Confirm"].tap()

        // Then
        XCTAssertTrue(app.alerts["Error"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.alerts["Error"].staticTexts["no transaction"].exists)
    }
}
