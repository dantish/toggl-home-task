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
        case retrieve
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

    func retrieve(completion: @escaping RetrievalCompletion) {
        receivedMessages.append(.retrieve)
    }
}
