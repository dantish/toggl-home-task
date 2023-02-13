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

    typealias LoadResult = Result<[TimeEntry], Error>

    func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
                
            case let .success(localTimeEntries):
                completion(.success(localTimeEntries.map {
                    TimeEntry(id: $0.id, startTime: $0.startTime, endTime: $0.endTime)
                }))
            }
        }
    }
}

final class LoadTimeEntriesFromCacheUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }

    func test_load_requestsCacheRetrieval() {
        let (sut, store) = makeSUT()

        sut.load() { _ in }

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }

    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = NSError(domain: "any error", code: 0)
        let exp = expectation(description: "Wait for load completion")

        var receivedError: Error?
        sut.load { result in
            if case let .failure(error) = result {
                receivedError = error
            }

            exp.fulfill()
        }

        store.completeRetrieval(with: retrievalError)
        wait(for: [exp], timeout: 1.0)

        XCTAssertEqual(receivedError as NSError?, retrievalError)
    }

    func test_load_deliversNoTimeEntriesOnEmptyCache() {
        let (sut, store) = makeSUT()
        let exp = expectation(description: "Wait for load completion")

        sut.load { receivedResult in
            switch receivedResult {
            case let .success(receivedTimeEntries):
                XCTAssertEqual(receivedTimeEntries, [])

            default:
                XCTFail("Expected successful result with no entries, but got \(receivedResult) instead")
            }

            exp.fulfill()
        }

        store.completeRetrievalWithEmptyCache()
        wait(for: [exp], timeout: 1.0)
    }

    func test_load_deliversCachedTimeEntriesOnNonEmptyCache() {
        let (sut, store) = makeSUT()
        let timeEntries = [uniqueTimeEntry(), uniqueTimeEntry()]
        let localTimeEntries = timeEntries.map { LocalTimeEntry(id: $0.id, startTime: $0.startTime, endTime: $0.endTime) }
        let exp = expectation(description: "Wait for load completion")

        sut.load { receivedResult in
            switch receivedResult {
            case let .success(receivedTimeEntries):
                XCTAssertEqual(receivedTimeEntries, timeEntries)

            default:
                XCTFail("Expected successful result with cached time entries, but got \(receivedResult) instead")
            }

            exp.fulfill()
        }

        store.completeRetrieval(with: localTimeEntries)
        wait(for: [exp], timeout: 1.0)
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: LoadTimeEntriesFromCacheUseCase, store: TimeEntriesStoreSpy) {
        let store = TimeEntriesStoreSpy()
        let sut = LoadTimeEntriesFromCacheUseCase(store: store)
        return (sut, store)
    }

    private func uniqueTimeEntry() -> TimeEntry {
        TimeEntry(
            id: UUID(),
            startTime: Date(timeIntervalSinceNow: -10),
            endTime: Date()
        )
    }

}
