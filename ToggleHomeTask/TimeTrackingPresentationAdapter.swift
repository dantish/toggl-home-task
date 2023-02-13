//
//  TimeTrackingPresentationAdapter.swift
//  ToggleHomeTask
//
//  Created by Daniel Tischenko on 13.02.2023.
//

import Foundation
import Combine

final class TimeTrackingPresentationAdapter {
    private let onTimeEntryCreated: (TimeEntry) -> Void
    private var cancellable: Cancellable?
    private var startTime: Date?
    private var currentInterval = 0

    var presenter: TimeTrackingPresenter?

    init(onTimeEntryCreated: @escaping (TimeEntry) -> Void) {
        self.onTimeEntryCreated = onTimeEntryCreated
    }

    func onViewLoaded() {
        presenter?.didLoadView()
    }

    func onStopwatchToggled() {
        if let startTime {
            self.startTime = nil
            cancellable = nil
            currentInterval = 0
            presenter?.didStopStopwatch()

            return onTimeEntryCreated(TimeEntry(
                id: UUID(),
                startTime: startTime,
                endTime: .now
            ))
        }

        startTime = .now
        presenter?.didStartStopwatch()

        cancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] currentTime in
                guard let self else { return }
                self.currentInterval += 1
                self.presenter?.didUpdateStopwatch(with: self.currentInterval)
            }
    }
}
