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
    private var timeEntries: [LocalTimeEntry] = []

    func insert(_ timeEntry: ToggleHomeTask.LocalTimeEntry, completion: @escaping InsertionCompletion) {
        timeEntries.append(timeEntry)
        completion(.success(()))
    }

    func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.success(timeEntries))
    }
}

final class InMemoryTimeEntriesStoreTests: XCTestCase {

    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()

        expect(sut, toRetrieve: .success([]))
    }

    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()

        expect(sut, toRetrieveTwice: .success([]))
    }

    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
        let sut = makeSUT()
        let timeEntry = uniqueTimeEntry().local

        insert(timeEntry, to: sut)

        expect(sut, toRetrieve: .success([timeEntry]))
    }

    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        let timeEntry = uniqueTimeEntry().local

        insert(timeEntry, to: sut)

        expect(sut, toRetrieveTwice: .success([timeEntry]))
    }

    func test_insert_deliversNoErrorOnEmptyCache() {
        let sut = makeSUT()

        let insertionError = insert(uniqueTimeEntry().local, to: sut)

        XCTAssertNil(insertionError, "Expected to insert cache successfully")
    }

    func test_insert_deliversNoErrorOnNonEmptyCache() {
        let sut = makeSUT()
        insert(uniqueTimeEntry().local, to: sut)

        let insertionError = insert(uniqueTimeEntry().local, to: sut)

        XCTAssertNil(insertionError, "Expected to insert additional cache successfully")
    }

    func test_insert_appendsToPreviouslyInsertedCacheValues() {
        let sut = makeSUT()
        let previousTimeEntry = uniqueTimeEntry().local
        insert(previousTimeEntry, to: sut)

        let newTimeEntry = uniqueTimeEntry().local
        insert(newTimeEntry, to: sut)

        expect(sut, toRetrieve: .success([previousTimeEntry, newTimeEntry]))
    }

    func test_storeSideEffects_runSerially() {
        let sut = makeSUT()
        var completedOperationsInOrder = [XCTestExpectation]()

        let op1 = expectation(description: "Operation 1")
        sut.insert(uniqueTimeEntry().local) { _ in
            completedOperationsInOrder.append(op1)
            op1.fulfill()
        }

        let op2 = expectation(description: "Operation 2")
        sut.insert(uniqueTimeEntry().local) { _ in
            completedOperationsInOrder.append(op2)
            op2.fulfill()
        }

        let op3 = expectation(description: "Operation 3")
        sut.insert(uniqueTimeEntry().local) { _ in
            completedOperationsInOrder.append(op3)
            op3.fulfill()
        }

        waitForExpectations(timeout: 5.0)

        XCTAssertEqual(completedOperationsInOrder, [op1, op2, op3], "Expected side-effects to run serially but operations finished in the wrong order")
    }

    // MARK: - Helpers

    private func makeSUT() -> TimeEntriesStore {
        InMemoryTimeEntriesStore()
    }

    @discardableResult
    func insert(_ cache: LocalTimeEntry, to sut: TimeEntriesStore) -> Error? {
        let insertionExp = expectation(description: "Wait for cache insertion")

        var insertionError: Error?
        sut.insert(cache) { result in
            if case let .failure(error) = result {
                insertionError = error
            }

            insertionExp.fulfill()
        }
        wait(for: [insertionExp], timeout: 1.0)

        return insertionError
    }

    func expect(
        _ sut: TimeEntriesStore,
        toRetrieveTwice expectedResult: TimeEntriesStore.RetrievalResult,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
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
