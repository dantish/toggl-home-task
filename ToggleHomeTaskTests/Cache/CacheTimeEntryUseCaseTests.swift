//
//  CacheTimeEntryUseCaseTests.swift
//  ToggleHomeTaskTests
//
//  Created by Daniel Tischenko on 11.02.2023.
//

import XCTest

protocol TimeEntriesStore {}

final class CacheTimeEntryUseCase {
    init(store: TimeEntriesStore) {}
}

final class CacheTimeEntryUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let store = TimeEntriesStoreSpy()

        let _ = CacheTimeEntryUseCase(store: store)

        XCTAssertEqual(store.receivedMessages, [])
    }

    // MARK: - Helpers

    private final class TimeEntriesStoreSpy: TimeEntriesStore {
        enum Message: Equatable {}

        let receivedMessages: [Message] = []
    }

}
