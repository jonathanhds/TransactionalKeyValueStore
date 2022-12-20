import XCTest
@testable import TransactionalKeyValueStore

final class TransactionalKeyValueStoreTests: XCTestCase {

    var store: TransactionalKeyValueStore!

    override func setUp() {
        store = TransactionalKeyValueStore()
    }

    override func tearDown() {
        store = nil
    }

    func testKeyNotFound() {
        // Given

        // When
        let result = store.run(.get("abc"))

        // Then
        XCTAssertEqual(result, .error("key not set"))
    }

    func testStoreKey() {
        // Given
        store.run(.set("foo", "123"))

        // When
        let result = store.run(.get("foo"))

        // Then
        XCTAssertEqual(result, .value("123"))
    }

    func testOverrideValue() {
        // Given
        store.run(.set("foo", "123"))

        // When
        store.run(.set("foo", "456"))

        // Then
        let result = store.run(.get("foo"))
        XCTAssertEqual(result, .value("456"))
    }

    func testDeleteKey() {
        // Given
        store.run(.set("foo", "123"))

        // When
        store.run(.delete("foo"))

        // Then
        let result = store.run(.get("foo"))
        XCTAssertEqual(result, .error("key not set"))
    }

    func testNotAbleToDeleteKey() {
        // Given
        store.run(.set("foo", "123"))

        // When
        let result = store.run(.delete("bar"))

        // Then
        XCTAssertEqual(result, .error("key not set"))
    }

    func testRollbackDelete() {
        // Given
        store.run(.set("foo", "123"))
        store.run(.begin)
        store.run(.delete("foo"))

        // When
        store.run(.rollback)

        // Then
        let result = store.run(.get("foo"))
        XCTAssertEqual(result, .value("123"))
    }

    func testCommandsThatReturnEmptyResult() {
        XCTAssertEqual(store.run(.set("foo", "123")), .empty)
        XCTAssertEqual(store.run(.delete("foo")), .empty)
        XCTAssertEqual(store.run(.begin), .empty)
        XCTAssertEqual(store.run(.commit), .empty)
    }

    func testCountNumberOfOccurences() {
        // Given
        store.run(.set("foo", "123"))
        store.run(.set("bar", "456"))
        store.run(.set("baz", "123"))

        // When
        let count123 = store.run(.count("123"))
        let count456 = store.run(.count("456"))
        let count789 = store.run(.count("789"))

        // Then
        XCTAssertEqual(count123, .value("2"))
        XCTAssertEqual(count456, .value("1"))
        XCTAssertEqual(count789, .value("0"))
    }

    func testCommitATransaction() {
        // Given
        store.run(.begin)
        store.run(.set("foo", "456"))

        // When
        store.run(.commit)

        // Then
        let rollbackResult = store.run(.rollback)
        XCTAssertEqual(rollbackResult, .error("no transaction"))

        XCTAssertEqual(store.run(.get("foo")), .value("456"))
    }

    func testTransactionToCommit() {
        // Given
        store.run(.set("foo", "456"))

        // When
        let result = store.run(.commit)

        // Then
        XCTAssertEqual(result, .error("no transaction"))
    }

    func testRollbackATransaction() {
        // Given
        store.run(.set("foo", "123"))
        store.run(.begin)
        store.run(.set("foo", "456"))

        // When
        store.run(.rollback)

        // Then
        let foo = store.run(.get("foo"))
        XCTAssertEqual(foo, .value("123"))
    }

    func testNoTransactionToRollback() {
        // Given
        store.run(.set("foo", "123"))

        // When
        let result = store.run(.rollback)

        // Then
        XCTAssertEqual(result, .error("no transaction"))
    }

    func testNestedTransactions() {
        // Given
        store.run(.set("foo", "123"))
        store.run(.begin)
        store.run(.set("bar", "456"))
        store.run(.set("foo", "456"))
        store.run(.begin)
        store.run(.set("foo", "789"))

        // When
        store.run(.rollback)

        // Then
        XCTAssertEqual(store.run(.get("foo")), .value("456"))
    }

    func testNestedTransactions_rollbackTwice() {
        // Given
        store.run(.set("foo", "123"))
        store.run(.begin)
        store.run(.set("bar", "456"))
        store.run(.set("foo", "456"))
        store.run(.begin)
        store.run(.set("foo", "789"))

        // When
        store.run(.rollback)
        store.run(.rollback)

        // Then
        XCTAssertEqual(store.run(.get("foo")), .value("123"))
    }
}
