//
//  RemoveTimeEntryFromCacheUseCaseTests.swift
//  ToggleHomeTaskTests
//
//  Created by Daniel Tischenko on 14.02.2023.
//

import XCTest
@testable import ToggleHomeTask

final class RemoveTimeEntryFromCacheUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }

    func test_remove_requestsTimeEntryDeletion() {
        let (sut, store) = makeSUT()
        let (model, local) = uniqueTimeEntry()

        sut.remove(model) { _ in }

        XCTAssertEqual(store.receivedMessages, [.delete(local)])
    }

    func test_remove_failsOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()

        expect(sut, toCompleteWithError: deletionError, when: {
            store.completeDeletion(with: deletionError)
        })
    }

    func test_remove_succeedsOnSuccessfulDeletion() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteWithError: nil, when: {
            store.completeDeletionSuccessfully()
        })
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: RemoveTimeEntryFromCacheUseCase, store: TimeEntriesStoreSpy) {
        let store = TimeEntriesStoreSpy()
        let sut = RemoveTimeEntryFromCacheUseCase(store: store)
        return (sut, store)
    }

    private func expect(
        _ sut: RemoveTimeEntryFromCacheUseCase,
        toCompleteWithError expectedError: NSError?,
        when action: () -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for save completion")

        var receivedError: Error?
        sut.remove(uniqueTimeEntry().model) { result in
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
