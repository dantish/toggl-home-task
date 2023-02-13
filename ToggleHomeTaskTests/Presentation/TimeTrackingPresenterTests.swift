//
//  TimeTrackingPresenterTests.swift
//  ToggleHomeTaskTests
//
//  Created by Daniel Tischenko on 13.02.2023.
//

import XCTest
@testable import ToggleHomeTask

protocol TimeTrackingView {
    func display(_ viewModel: TimeTrackingViewModel)
}

final class TimeTrackingPresenter {
    let view: TimeTrackingView

    init(view: TimeTrackingView) {
        self.view = view
    }

    func didLoadView() {
        view.display(TimeTrackingViewModel(
            stopwatchValue: "0",
            toggleActionTitle: "Start",
            isToggleActionDestructive: false
        ))
    }
}

final class TimeTrackingPresenterTests: XCTestCase {

    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }

    func test_didLoadView_displaysInitialValues() {
        let (sut, view) = makeSUT()

        sut.didLoadView()

        XCTAssertEqual(view.messages, [
            .display(stopwatchValue: "0", toggleActionTitle: "Start", isToggleActionDestructive: false),
        ])
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: TimeTrackingPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = TimeTrackingPresenter(view: view)
        return (sut, view)
    }

    private class ViewSpy: TimeTrackingView {
        enum Message: Equatable {
            case display(stopwatchValue: String, toggleActionTitle: String, isToggleActionDestructive: Bool)
        }

        private(set) var messages: [Message] = []

        func display(_ viewModel: TimeTrackingViewModel) {
            messages.append(.display(
                stopwatchValue: viewModel.stopwatchValue,
                toggleActionTitle: viewModel.toggleActionTitle,
                isToggleActionDestructive: viewModel.isToggleActionDestructive
            ))
        }
    }

}
