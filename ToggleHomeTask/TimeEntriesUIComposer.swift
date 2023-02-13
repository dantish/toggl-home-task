//
//  TimeEntriesUIComposer.swift
//  ToggleHomeTask
//
//  Created by Daniel Tischenko on 14.02.2023.
//

import UIKit
import Combine

final class TimeEntriesUIComposer {
    private init() {}

    static func timeEntriesComposedWith(
        timeEntriesLoader: @escaping () -> AnyPublisher<[TimeEntry], Error>,
        onTimeEntryRemoved: @escaping (TimeEntry) -> Void
    ) -> TimeEntriesViewController {
        let presentationAdapter = TimeEntriesLoaderPresentationAdapter(
            timeEntriesLoader: timeEntriesLoader,
            onTimeEntryRemoved: onTimeEntryRemoved
        )
        let timeEntriesVC = TimeEntriesViewController()

        presentationAdapter.presenter = TimeEntriesPresenter(
            timeEntriesView: WeakRefVirtualProxy(timeEntriesVC),
            loadingView: WeakRefVirtualProxy(timeEntriesVC)
        )

        timeEntriesVC.onRefresh = presentationAdapter.onRefresh
        timeEntriesVC.onRemove = presentationAdapter.onRemove

        return timeEntriesVC
    }
}

private final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?

    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: TimeEntriesView where T: TimeEntriesView {
    func display(_ viewModels: [TimeEntryViewModel]) {
        object?.display(viewModels)
    }
}

extension WeakRefVirtualProxy: TimeEntriesLoadingView where T: TimeEntriesLoadingView {
    func display(_ viewModel: TimeEntriesLoadingViewModel) {
        object?.display(viewModel)
    }
}
