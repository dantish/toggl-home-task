//
//  LoadTimeEntriesFromCacheUseCase.swift
//  ToggleHomeTask
//
//  Created by Daniel Tischenko on 13.02.2023.
//

import Foundation

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
