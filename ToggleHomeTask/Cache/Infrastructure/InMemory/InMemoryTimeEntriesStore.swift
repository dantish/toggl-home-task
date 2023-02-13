//
//  InMemoryTimeEntriesStore.swift
//  ToggleHomeTask
//
//  Created by Daniel Tischenko on 13.02.2023.
//

import Foundation

final class InMemoryTimeEntriesStore: TimeEntriesStore {
    private var timeEntries: [LocalTimeEntry] = []

    func insert(_ timeEntry: ToggleHomeTask.LocalTimeEntry, completion: @escaping InsertionCompletion) {
        timeEntries.append(timeEntry)
        completion(.success(()))
    }

    func delete(_ timeEntry: LocalTimeEntry, completion: @escaping DeletionCompletion) {
        timeEntries.removeAll { $0 == timeEntry }
        completion(.success(()))
    }

    func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.success(timeEntries))
    }
}
