//
//  TimeTrackingPresenter.swift
//  ToggleHomeTask
//
//  Created by Daniel Tischenko on 13.02.2023.
//

import Foundation

protocol TimeTrackingView {
    func display(_ viewModel: TimeTrackingViewModel)
}

final class TimeTrackingPresenter {
    private let view: TimeTrackingView
    private let stopwatchValueFormatter: (Int) -> String

    init(view: TimeTrackingView, stopwatchValueFormatter: @escaping (Int) -> String) {
        self.view = view
        self.stopwatchValueFormatter = stopwatchValueFormatter
    }

    func didLoadView() {
        view.display(TimeTrackingViewModel(
            stopwatchValue: stopwatchValueFormatter(0),
            toggleActionTitle: "Start",
            isToggleActionDestructive: false
        ))
    }

    func didStartStopwatch() {
        view.display(TimeTrackingViewModel(
            stopwatchValue: stopwatchValueFormatter(0),
            toggleActionTitle: "Stop",
            isToggleActionDestructive: true
        ))
    }

    func didUpdateStopwatch(with value: Int) {
        view.display(TimeTrackingViewModel(
            stopwatchValue: stopwatchValueFormatter(value),
            toggleActionTitle: "Stop",
            isToggleActionDestructive: true
        ))
    }

    func didStopStopwatch() {
        view.display(TimeTrackingViewModel(
            stopwatchValue: stopwatchValueFormatter(0),
            toggleActionTitle: "Start",
            isToggleActionDestructive: false
        ))
    }
}
