//
//  TimeTrackingUIComposer.swift
//  ToggleHomeTask
//
//  Created by Daniel Tischenko on 13.02.2023.
//

import UIKit
import Combine

final class TimeTrackingUIComposer {
    private init() {}

    static func timeTracking(onTimeEntryCreated: @escaping (TimeEntry) -> Void) -> TimeTrackingViewController {
        let presentationAdapter = TimeTrackingPresentationAdapter(onTimeEntryCreated: onTimeEntryCreated)
        let timeTrackingVC = makeTimeTrackingViewController()

        presentationAdapter.presenter = TimeTrackingPresenter(
            view: WeakRefVirtualProxy(timeTrackingVC),
            // TODO: Provide a more user-friendly formatter (like hh:mm:ss)
            stopwatchValueFormatter: String.init
        )

        timeTrackingVC.onViewLoaded = presentationAdapter.onViewLoaded
        timeTrackingVC.onStopwatchToggled = presentationAdapter.onStopwatchToggled

        return timeTrackingVC
    }

    private static func makeTimeTrackingViewController() -> TimeTrackingViewController {
        let bundle = Bundle(for: TimeTrackingViewController.self)
        let storyboard = UIStoryboard(name: "TimeTracking", bundle: bundle)
        return storyboard.instantiateInitialViewController() as! TimeTrackingViewController
    }
}

private final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?

    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: TimeTrackingView where T: TimeTrackingView {
    func display(_ viewModel: TimeTrackingViewModel) {
        object?.display(viewModel)
    }
}
