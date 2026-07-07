import XCTest
@testable import Stairstack

@MainActor
final class StairstackTests: XCTestCase {
    func testSeedDataLoaded() {
        let store = Store()
        XCTAssertFalse(store.entries.isEmpty)
    }

    func testSeedCountBelowFreeLimit() {
        let store = Store()
        XCTAssertLessThan(store.entries.count, Store.freeLimit)
    }

    func testAddEntry() {
        let store = Store()
        let before = store.entries.count
        store.add(Entry())
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func testDeleteEntry() {
        let store = Store()
        let entry = Entry()
        store.add(entry)
        let before = store.entries.count
        store.delete(entry)
        XCTAssertEqual(store.entries.count, before - 1)
    }

    func testCanAddMoreWhenUnderLimit() {
        let store = Store()
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreAtLimit() {
        let store = Store()
        store.entries = (0..<Store.freeLimit).map { _ in Entry() }
        XCTAssertFalse(store.canAddMore)
    }

    func testUpdateEntry() {
        let store = Store()
        var entry = Entry()
        store.add(entry)
        entry.date = Date.distantPast
        store.update(entry)
        XCTAssertEqual(store.entries.first(where: { $0.id == entry.id })?.date, Date.distantPast)
    }

    func testDeleteAtOffsets() {
        let store = Store()
        store.entries = [Entry(), Entry(), Entry()]
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.entries.count, 2)
    }
}
