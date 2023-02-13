//
//  CacheTimeEntryUseCaseTests.swift
//  ToggleHomeTaskTests
//
//  Created by Daniel Tischenko on 11.02.2023.
//

import XCTest
@testable import ToggleHomeTask

struct LocalTimeEntry: Equatable {
    let id: UUID
    let startTime: Date
    let endTime: Date
}

protocol TimeEntriesStore {
    typealias InsertionResult = Result<Void, Error>
    typealias InsertionCompletion = (InsertionResult) -> Void

    func insert(_ timeEntry: LocalTimeEntry, completion: @escaping InsertionCompletion)
}

final class CacheTimeEntryUseCase {
    let store: TimeEntriesStore

    init(store: TimeEntriesStore) {
        self.store = store
    }

    func save(_ timeEntry: TimeEntry) {
        let local = LocalTimeEntry(
            id: timeEntry.id,
            startTime: timeEntry.startTime,
            endTime: timeEntry.endTime
        )

        store.insert(local) { _ in }
    }
}

final class CacheTimeEntryUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let store = TimeEntriesStoreSpy()

        let _ = CacheTimeEntryUseCase(store: store)

        XCTAssertEqual(store.receivedMessages, [])
    }

    func test_save_requestsTimeEntryInsertion() {
        let store = TimeEntriesStoreSpy()
        let sut = CacheTimeEntryUseCase(store: store)
        let model = uniqueTimeEntry()
        let local = LocalTimeEntry(
            id: model.id,
            startTime: model.startTime,
            endTime: model.endTime
        )

        sut.save(model)

        XCTAssertEqual(store.receivedMessages, [.insert(local)])
    }

    // MARK: - Helpers

    private func uniqueTimeEntry() -> TimeEntry {
        TimeEntry(
            id: UUID(),
            startTime: Date(timeIntervalSinceNow: -10),
            endTime: Date()
        )
    }

    private final class TimeEntriesStoreSpy: TimeEntriesStore {
        enum Message: Equatable {
            case insert(LocalTimeEntry)
        }

        private(set) var receivedMessages: [Message] = []

        func insert(_ timeEntry: LocalTimeEntry, completion: @escaping InsertionCompletion) {
            receivedMessages.append(.insert(timeEntry))
        }
    }

}
