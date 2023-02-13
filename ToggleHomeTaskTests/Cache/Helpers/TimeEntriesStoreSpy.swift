//
//  TimeEntriesStoreSpy.swift
//  ToggleHomeTaskTests
//
//  Created by Daniel Tischenko on 13.02.2023.
//

import Foundation
@testable import ToggleHomeTask

final class TimeEntriesStoreSpy: TimeEntriesStore {
    enum Message: Equatable {
        case insert(LocalTimeEntry)
        case delete(LocalTimeEntry)
        case retrieve
    }

    private(set) var receivedMessages: [Message] = []

    private var insertionCompletions: [InsertionCompletion] = []
    private var deletionCompletions: [DeletionCompletion] = []
    private var retrievalCompletions: [RetrievalCompletion] = []

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

    func delete(_ timeEntry: LocalTimeEntry, completion: @escaping DeletionCompletion) {
        deletionCompletions.append(completion)
        receivedMessages.append(.delete(timeEntry))
    }

    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](.failure(error))
    }

    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](.success(()))
    }

    func retrieve(completion: @escaping RetrievalCompletion) {
        retrievalCompletions.append(completion)
        receivedMessages.append(.retrieve)
    }

    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }

    func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrievalCompletions[index](.success([]))
    }

    func completeRetrieval(with timeEntries: [LocalTimeEntry], at index: Int = 0) {
        retrievalCompletions[index](.success(timeEntries))
    }
}
