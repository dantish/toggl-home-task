//
//  CacheTimeEntryUseCase.swift
//  ToggleHomeTask
//
//  Created by Daniel Tischenko on 13.02.2023.
//

import Foundation

final class CacheTimeEntryUseCase {
    private let store: TimeEntriesStore

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
            case .success:
                completion(.success(()))
            }
        }
    }
}
