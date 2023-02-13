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
                completion(.success(localTimeEntries.map { $0.toModel() }))
            }
        }
    }
}

private extension LocalTimeEntry {
    func toModel() -> TimeEntry {
        TimeEntry(
            id: id,
            startTime: startTime,
            endTime: endTime
        )
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

        expect(sut, toCompleteWith: .failure(retrievalError), when: {
            store.completeRetrieval(with: retrievalError)
        })
    }

    func test_load_deliversNoTimeEntriesOnEmptyCache() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteWith: .success([]), when: {
            store.completeRetrievalWithEmptyCache()
        })
    }

    func test_load_deliversCachedTimeEntriesOnNonEmptyCache() {
        let (sut, store) = makeSUT()
        let timeEntries = [uniqueTimeEntry(), uniqueTimeEntry()]
        let localTimeEntries = timeEntries.map { LocalTimeEntry(id: $0.id, startTime: $0.startTime, endTime: $0.endTime) }

        expect(sut, toCompleteWith: .success(timeEntries), when: {
            store.completeRetrieval(with: localTimeEntries)
        })
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

    private func expect(
        _ sut: LoadTimeEntriesFromCacheUseCase,
        toCompleteWith expectedResult: LoadTimeEntriesFromCacheUseCase.LoadResult,
        when action: () -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for load completion")

        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedTimeEntries), .success(expectedTimeEntries)):
                XCTAssertEqual(receivedTimeEntries, expectedTimeEntries, file: file, line: line)

            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)

            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        action()
        wait(for: [exp], timeout: 1.0)
    }

}
