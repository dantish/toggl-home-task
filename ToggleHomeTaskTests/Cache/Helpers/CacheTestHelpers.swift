//
//  CacheTestHelpers.swift
//  ToggleHomeTaskTests
//
//  Created by Daniel Tischenko on 13.02.2023.
//

import Foundation
@testable import ToggleHomeTask

func uniqueTimeEntry() -> (model: TimeEntry, local: LocalTimeEntry) {
    let model = TimeEntry(
        id: UUID(),
        startTime: Date(timeIntervalSinceNow: -10),
        endTime: Date()
    )
    let local = LocalTimeEntry(
        id: model.id,
        startTime: model.startTime,
        endTime: model.endTime
    )
    return (model, local)
}

func uniqueTimeEntries() -> (models: [TimeEntry], local: [LocalTimeEntry]) {
    let combined = [uniqueTimeEntry(), uniqueTimeEntry()]
    let models = combined.map(\.model)
    let local = combined.map(\.local)
    return (models, local)
}
