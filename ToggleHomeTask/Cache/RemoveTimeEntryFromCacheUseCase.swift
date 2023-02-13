//
//  RemoveTimeEntryFromCacheUseCase.swift
//  ToggleHomeTask
//
//  Created by Daniel Tischenko on 14.02.2023.
//

import Foundation

final class RemoveTimeEntryFromCacheUseCase {
    private let store: TimeEntriesStore

    init(store: TimeEntriesStore) {
        self.store = store
    }

    public typealias RemoveResult = Result<Void, Error>

    func remove(_ timeEntry: TimeEntry, completion: @escaping (RemoveResult) -> Void) {
        let local = LocalTimeEntry(
            id: timeEntry.id,
            startTime: timeEntry.startTime,
            endTime: timeEntry.endTime
        )

        store.delete(local) { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case .success:
                completion(.success(()))
            }
        }
    }
}
