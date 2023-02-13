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

    public typealias SaveResult = Result<Void, Error>

    func save(_ timeEntry: TimeEntry, completion: @escaping (SaveResult) -> Void) {
        let local = LocalTimeEntry(
            id: timeEntry.id,
            startTime: timeEntry.startTime,
            endTime: timeEntry.endTime
        )

        store.insert(local) { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            default:
                completion(.success(()))
            }
        }
    }
}

final class CacheTimeEntryUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }

    func test_save_requestsTimeEntryInsertion() {
        let (sut, store) = makeSUT()
        let model = uniqueTimeEntry()
        let local = LocalTimeEntry(
            id: model.id,
            startTime: model.startTime,
            endTime: model.endTime
        )

        sut.save(model) { _ in }

        XCTAssertEqual(store.receivedMessages, [.insert(local)])
    }

    func test_save_failsOnInsertionError() {
        let (sut, store) = makeSUT()
        let insertionError = NSError(domain: "any error", code: 0)
        let exp = expectation(description: "Wait for save completion")

        var receivedError: Error?
        sut.save(uniqueTimeEntry()) { result in
            if case let .failure(error) = result {
                receivedError = error
            }

            exp.fulfill()
        }

        store.completeInsertion(with: insertionError)
        wait(for: [exp], timeout: 1.0)

        XCTAssertEqual(receivedError as NSError?, insertionError)
    }

    func test_save_succeedsOnSuccessfulInsertion() {
        let (sut, store) = makeSUT()
        let exp = expectation(description: "Wait for save completion")

        sut.save(uniqueTimeEntry()) { result in
            if case let .failure(error) = result {
                XCTFail("Expected to complete successfully, but got \(error) instead")
            }

            exp.fulfill()
        }

        store.completeInsertionSuccessfully()
        wait(for: [exp], timeout: 1.0)
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: CacheTimeEntryUseCase, store: TimeEntriesStoreSpy) {
        let store = TimeEntriesStoreSpy()
        let sut = CacheTimeEntryUseCase(store: store)
        return (sut, store)
    }

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

        private var insertionCompletions: [InsertionCompletion] = []

        func insert(_ timeEntry: LocalTimeEntry, completion: @escaping InsertionCompletion) {
            insertionCompletions.append(completion)
            receivedMessages.append(.insert(timeEntry))
        }

        func completeInsertion(with error: Error, at index: Int = 0) {
            insertionCompletions[index](.failure(error))
        }

        func completeInsertionSuccessfully(at index: Int = 0) {
            insertionCompletions[index](.success(()))
        }
    }

}
