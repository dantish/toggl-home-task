//
//  TimeEntriesStore.swift
//  ToggleHomeTask
//
//  Created by Daniel Tischenko on 13.02.2023.
//

import Foundation

protocol TimeEntriesStore {
    typealias InsertionResult = Result<Void, Error>
    typealias InsertionCompletion = (InsertionResult) -> Void

    typealias RetrievalResult = Result<[LocalTimeEntry], Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void

    func insert(_ timeEntry: LocalTimeEntry, completion: @escaping InsertionCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
}
