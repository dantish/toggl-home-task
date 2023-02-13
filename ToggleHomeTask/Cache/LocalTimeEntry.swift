//
//  LocalTimeEntry.swift
//  ToggleHomeTask
//
//  Created by Daniel Tischenko on 13.02.2023.
//

import Foundation

struct LocalTimeEntry: Equatable {
    let id: UUID
    let startTime: Date
    let endTime: Date
}
