//
//  TimeEntry.swift
//  ToggleHomeTask
//
//  Created by Daniel Tischenko on 11.02.2023.
//

import Foundation

struct TimeEntry: Equatable {
    let id: UUID
    let startTime: Date
    let endTime: Date
}
