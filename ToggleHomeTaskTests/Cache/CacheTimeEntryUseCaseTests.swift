//
//  CacheTimeEntryUseCaseTests.swift
//  ToggleHomeTaskTests
//
//  Created by Daniel Tischenko on 11.02.2023.
//

import XCTest
@testable import ToggleHomeTask

final class CacheTimeEntryUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }

    func test_save_requestsTimeEntryInsertion() {
        let (sut, store) = makeSUT()
        let (model, local) = uniqueTimeEntry()

        sut.save(model) { _ in }

        XCTAssertEqual(store.receivedMessages, [.insert(local)])
    }

    func test_save_failsOnInsertionError() {
        let (sut, store) = makeSUT()
        let insertionError = NSError(domain: "any error", code: 0)

        expect(sut, toCompleteWithError: insertionError, when: {
            store.completeInsertion(with: insertionError)
        })
    }

    func test_save_succeedsOnSuccessfulInsertion() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteWithError: nil, when: {
            store.completeInsertionSuccessfully()
        })
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: CacheTimeEntryUseCase, store: TimeEntriesStoreSpy) {
        let store = TimeEntriesStoreSpy()
        let sut = CacheTimeEntryUseCase(store: store)
        return (sut, store)
    }

    private func expect(
        _ sut: CacheTimeEntryUseCase,
        toCompleteWithError expectedError: NSError?,
        when action: () -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for save completion")

        var receivedError: Error?
        sut.save(uniqueTimeEntry().model) { result in
            if case let .failure(error) = result {
                receivedError = error
            }

            exp.fulfill()
        }

        action()
        wait(for: [exp], timeout: 1.0)

        XCTAssertEqual(receivedError as NSError?, expectedError, file: file, line: line)
    }

}
