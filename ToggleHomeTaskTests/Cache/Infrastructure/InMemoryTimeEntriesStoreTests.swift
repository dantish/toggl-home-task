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
    func insert(_ timeEntry: ToggleHomeTask.LocalTimeEntry, completion: @escaping InsertionCompletion) {

    }

    func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.success([]))
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

    // MARK: - Helpers

    private func makeSUT() -> TimeEntriesStore {
        InMemoryTimeEntriesStore()
    }

}
