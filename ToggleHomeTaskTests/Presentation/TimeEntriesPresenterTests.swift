//
//  TimeEntriesPresenterTests.swift
//  ToggleHomeTaskTests
//
//  Created by Daniel Tischenko on 13.02.2023.
//

import XCTest
@testable import ToggleHomeTask

protocol TimeEntriesView {
    func display(_ viewModels: [TimeEntryViewModel])
}

struct TimeEntriesLoadingViewModel {
    public let isLoading: Bool
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

final class TimeEntriesPresenterTests: XCTestCase {

    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }

    func test_didStartLoadingTimeEntries_startsLoading() {
        let (sut, view) = makeSUT()

        sut.didStartLoadingTimeEntries()

        XCTAssertEqual(view.messages, [.display(isLoading: true)])
    }

    func test_didFinishLoadingTimeEntries_displaysTimeEntriesAndStopsLoading() {
        let (sut, view) = makeSUT()
        let now = Date.now

        let timeEntry0 = TimeEntry(id: UUID(), startTime: now, endTime: now.addingTimeInterval(150))
        let viewModel0 = TimeEntryViewModel(title: "2:30")

        let timeEntry1 = TimeEntry(id: UUID(), startTime: now.addingTimeInterval(50), endTime: now.addingTimeInterval(350))
        let viewModel1 = TimeEntryViewModel(title: "5:00")

        sut.didFinishLoadingTimeEntries(with: [timeEntry0, timeEntry1])

        XCTAssertEqual(view.messages, [
            .display(viewModels: [viewModel0, viewModel1].map(\.title)),
            .display(isLoading: false)
        ])
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: TimeEntriesPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = TimeEntriesPresenter(timeEntriesView: view, loadingView: view)
        return (sut, view)
    }

    private class ViewSpy: TimeEntriesView, TimeEntriesLoadingView {
        enum Message: Hashable {
            case display(viewModels: [String])
            case display(isLoading: Bool)
        }

        private(set) var messages: [Message] = []

        func display(_ viewModels: [TimeEntryViewModel]) {
            messages.append(.display(viewModels: viewModels.map(\.title)))
        }

        func display(_ viewModel: TimeEntriesLoadingViewModel) {
            messages.append(.display(isLoading: viewModel.isLoading))
        }
    }

}
