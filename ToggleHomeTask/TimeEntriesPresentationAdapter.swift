//
//  TimeEntriesPresentationAdapter.swift
//  ToggleHomeTask
//
//  Created by Daniel Tischenko on 14.02.2023.
//

import Foundation
import Combine

final class TimeEntriesLoaderPresentationAdapter {
    private let timeEntriesLoader: () -> AnyPublisher<[TimeEntry], Error>
    private let onTimeEntryRemoved: (TimeEntry) -> Void
    private var cancellable: Cancellable?
    private var timeEntries: [TimeEntry] = []

    var presenter: TimeEntriesPresenter?

    init(
        timeEntriesLoader: @escaping () -> AnyPublisher<[TimeEntry], Error>,
        onTimeEntryRemoved: @escaping (TimeEntry) -> Void
    ) {
        self.timeEntriesLoader = timeEntriesLoader
        self.onTimeEntryRemoved = onTimeEntryRemoved
    }

    func onRefresh() {
        presenter?.didStartLoadingTimeEntries()

        cancellable = timeEntriesLoader()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure = completion {
                    self?.timeEntries = []
                    self?.presenter?.didFinishLoadingTimeEntries(with: [])
                }
            }, receiveValue: { [weak self] timeEntries in
                self?.timeEntries = timeEntries
                self?.presenter?.didFinishLoadingTimeEntries(with: timeEntries)
            })
    }

    func onRemove(at index: Int) {
        onTimeEntryRemoved(timeEntries[index])
        onRefresh()
    }
}

