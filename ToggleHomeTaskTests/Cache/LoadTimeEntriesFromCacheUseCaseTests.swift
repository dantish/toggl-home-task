//
//  LoadTimeEntriesFromCacheUseCaseTests.swift
//  ToggleHomeTaskTests
//
//  Created by Daniel Tischenko on 13.02.2023.
//

import XCTest
@testable import ToggleHomeTask

final class LoadTimeEntriesFromCacheUseCase {
    private let store: TimeEntriesStore

    init(store: TimeEntriesStore) {
        self.store = store
    }

    func load() {
        store.retrieve { _ in }
    }
}

final class LoadTimeEntriesFromCacheUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }

    func test_load_requestsCacheRetrieval() {
        let (sut, store) = makeSUT()

        sut.load()

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: LoadTimeEntriesFromCacheUseCase, store: TimeEntriesStoreSpy) {
        let store = TimeEntriesStoreSpy()
        let sut = LoadTimeEntriesFromCacheUseCase(store: store)
        return (sut, store)
    }

}
