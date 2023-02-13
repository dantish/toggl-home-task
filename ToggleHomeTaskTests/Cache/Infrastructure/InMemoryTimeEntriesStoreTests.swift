//
//  InMemoryTimeEntriesStoreTests.swift
//  ToggleHomeTaskTests
//
//  Created by Daniel Tischenko on 13.02.2023.
//

//
//  LoadTimeEntriesFromCacheUseCaseTests.swift
//  ToggleHomeTaskTests
//
//  Created by Daniel Tischenko on 13.02.2023.
//

import XCTest
@testable import ToggleHomeTask

final class InMemoryTimeEntriesStore: TimeEntriesStore {
    private var timeEntry: LocalTimeEntry?

    func insert(_ timeEntry: ToggleHomeTask.LocalTimeEntry, completion: @escaping InsertionCompletion) {
        self.timeEntry = timeEntry
        completion(.success(()))
    }

    func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.success([timeEntry].compactMap { $0 }))
    }
}

final class InMemoryTimeEntriesStoreTests: XCTestCase {

    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        let exp = expectation(description: "Wait for cache retrieval")

        sut.retrieve { retrievedResult in
            switch retrievedResult {
            case .success([]):
                break

            default:
                XCTFail("Expected to retrieve empty cache, got \(retrievedResult) instead")
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
        let sut = makeSUT()
        let timeEntry = uniqueTimeEntry().local

        let insertionExp = expectation(description: "Wait for cache insertion")
        sut.insert(timeEntry) { _ in insertionExp.fulfill() }
        wait(for: [insertionExp], timeout: 1.0)

        let retrievalExp = expectation(description: "Wait for cache retrieval")
        sut.retrieve { retrievedResult in
            switch retrievedResult {
            case let .success(receivedTimeEntries):
                XCTAssertEqual(receivedTimeEntries, [timeEntry])

            default:
                XCTFail("Expected to retrieve found values, got \(retrievedResult) instead")
            }

            retrievalExp.fulfill()
        }
        wait(for: [retrievalExp], timeout: 1.0)
    }

    // MARK: - Helpers

    private func makeSUT() -> TimeEntriesStore {
        InMemoryTimeEntriesStore()
    }

}
