//
//  CodableTimeEntriesStoreTests.swift
//  ToggleHomeTask
//
//  Created by Daniel Tischenko on 14.02.2023.
//


import Foundation

final class CodableTimeEntriesStore: TimeEntriesStore {
    func insert(_ timeEntry: ToggleHomeTask.LocalTimeEntry, completion: @escaping InsertionCompletion) {
        var timeEntries = load()
        timeEntries.append(timeEntry)

        if let error = save(timeEntries) {
            completion(.failure(error))
        } else {
            completion(.success(()))
        }
    }

    func delete(_ timeEntry: LocalTimeEntry, completion: @escaping DeletionCompletion) {
        var timeEntries = load()
        timeEntries.removeAll { $0 == timeEntry }

        if let error = save(timeEntries) {
            completion(.failure(error))
        } else {
            completion(.success(()))
        }
    }

    func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.success(load()))
    }

    private func load() -> [LocalTimeEntry] {
        do {
            let fileURL = try fileURL()

            guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                return []
            }

            return try JSONDecoder().decode([LocalTimeEntry].self, from: file.availableData)
        } catch {
            return []
        }
    }

    private func save(_ timeEntries: [LocalTimeEntry]) -> Error? {
        do {
            let data = try JSONEncoder().encode(timeEntries)
            let outfile = try fileURL()

            try data.write(to: outfile)

            return nil
        } catch {
            return error
        }
    }

    private func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
            .appendingPathComponent("togglTimeEntries.data")
    }
}
