//
//  TimeEntriesPresenter.swift
//  ToggleHomeTask
//
//  Created by Daniel Tischenko on 13.02.2023.
//

import Foundation

protocol TimeEntriesView {
    func display(_ viewModels: [TimeEntryViewModel])
}

protocol TimeEntriesLoadingView {
    func display(_ viewModel: TimeEntriesLoadingViewModel)
}

final class TimeEntriesPresenter {
    let timeEntriesView: TimeEntriesView
    let loadingView: TimeEntriesLoadingView

    init(timeEntriesView: TimeEntriesView, loadingView: TimeEntriesLoadingView) {
        self.timeEntriesView = timeEntriesView
        self.loadingView = loadingView
    }

    func didStartLoadingTimeEntries() {
        loadingView.display(TimeEntriesLoadingViewModel(isLoading: true))
    }

    func didFinishLoadingTimeEntries(with timeEntries: [TimeEntry]) {
        timeEntriesView.display(timeEntries.map { timeEntry in
            let formattedDuration = (timeEntry.startTime..<timeEntry.endTime).formatted(.timeDuration)
            return TimeEntryViewModel(title: formattedDuration)
        })
        loadingView.display(TimeEntriesLoadingViewModel(isLoading: false))
    }
}
