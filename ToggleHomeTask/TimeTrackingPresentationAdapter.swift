//
//  TimeTrackingPresentationAdapter.swift
//  ToggleHomeTask
//
//  Created by Daniel Tischenko on 13.02.2023.
//

import Foundation
import Combine

final class TimeTrackingPresentationAdapter {
    private var cancellable: Cancellable?
    private var currentInterval = 0

    var presenter: TimeTrackingPresenter?

    func onViewLoaded() {
        presenter?.didLoadView()
    }

    func onStopwatchToggled() {
        guard cancellable == nil else {
            cancellable = nil
            currentInterval = 0
            presenter?.didStopStopwatch()
            return
        }

        presenter?.didStartStopwatch()

        cancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currentTime in
                guard let self else { return }
                self.currentInterval += 1
                self.presenter?.didUpdateStopwatch(with: self.currentInterval)
            }
    }
}
