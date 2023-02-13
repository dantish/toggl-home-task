//
//  TimeEntriesPresenterTests.swift
//  ToggleHomeTaskTests
//
//  Created by Daniel Tischenko on 13.02.2023.
//

import XCTest

struct TimeEntriesLoadingViewModel {
    public let isLoading: Bool
}

protocol TimeEntriesLoadingView {
    func display(_ viewModel: TimeEntriesLoadingViewModel)
}

final class TimeEntriesPresenter {
    let loadingView: TimeEntriesLoadingView

    init(loadingView: TimeEntriesLoadingView) {
        self.loadingView = loadingView
    }

    func didStartLoadingTimeEntries() {
        loadingView.display(TimeEntriesLoadingViewModel(isLoading: true))
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

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: TimeEntriesPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = TimeEntriesPresenter(loadingView: view)
        return (sut, view)
    }

    private class ViewSpy: TimeEntriesLoadingView {
        enum Message: Hashable {
            case display(isLoading: Bool)
        }

        private(set) var messages: [Message] = []

        func display(_ viewModel: TimeEntriesLoadingViewModel) {
            messages.append(.display(isLoading: viewModel.isLoading))
        }
    }

}
