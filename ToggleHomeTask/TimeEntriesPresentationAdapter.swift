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
    private var cancellable: Cancellable?

    var presenter: TimeEntriesPresenter?

    init(timeEntriesLoader: @escaping () -> AnyPublisher<[TimeEntry], Error>) {
        self.timeEntriesLoader = timeEntriesLoader
    }

    func onRefresh() {
        presenter?.didStartLoadingTimeEntries()

        cancellable = timeEntriesLoader()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure = completion {
                    self?.presenter?.didFinishLoadingTimeEntries(with: [])
                }
            }, receiveValue: { [weak self] timeEntries in
                self?.presenter?.didFinishLoadingTimeEntries(with: timeEntries)
            })
    }
}

