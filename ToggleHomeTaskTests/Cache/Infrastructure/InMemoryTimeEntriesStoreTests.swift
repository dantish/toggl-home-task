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

        expect(sut, toRetrieve: .success([]))
    }

    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
        let sut = makeSUT()
        let timeEntry = uniqueTimeEntry().local

        insert(timeEntry, to: sut)

        expect(sut, toRetrieve: .success([timeEntry]))
    }

    // MARK: - Helpers

    private func makeSUT() -> TimeEntriesStore {
        InMemoryTimeEntriesStore()
    }

    func insert(_ cache: LocalTimeEntry, to sut: TimeEntriesStore) {
        let insertionExp = expectation(description: "Wait for cache insertion")
        sut.insert(cache) { _ in insertionExp.fulfill() }
        wait(for: [insertionExp], timeout: 1.0)
    }

    func expect(
        _ sut: TimeEntriesStore,
        toRetrieve expectedResult: TimeEntriesStore.RetrievalResult,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for cache retrieval")

        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.failure, .failure):
                break

            case let (.success(expected), .success(retrieved)):
                XCTAssertEqual(retrieved, expected, file: file, line: line)

            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

}
