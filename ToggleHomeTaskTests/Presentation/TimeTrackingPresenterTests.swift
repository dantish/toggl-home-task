//
//  TimeTrackingPresenterTests.swift
//  ToggleHomeTaskTests
//
//  Created by Daniel Tischenko on 13.02.2023.
//

import XCTest
@testable import ToggleHomeTask

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

    func test_didStartStopwatch_displaysUpdatedValues() {
        let (sut, view) = makeSUT()

        sut.didStartStopwatch()

        XCTAssertEqual(view.messages, [
            .display(stopwatchValue: "0", toggleActionTitle: "Stop", isToggleActionDestructive: true),
        ])
    }

    func test_didUpdateStopwatch_displaysFormattedValues() {
        let (sut, view) = makeSUT()

        sut.didUpdateStopwatch(with: 3723)

        XCTAssertEqual(view.messages, [
            .display(stopwatchValue: "3723", toggleActionTitle: "Stop", isToggleActionDestructive: true),
        ])
    }

    func test_didStopStopwatch_displaysInitialValues() {
        let (sut, view) = makeSUT()

        sut.didStopStopwatch()

        XCTAssertEqual(view.messages, [
            .display(stopwatchValue: "0", toggleActionTitle: "Start", isToggleActionDestructive: false),
        ])
    }

    // MARK: - Helpers

    private func makeSUT(stopwatchValueFormatter: @escaping (Int) -> String = String.init) -> (sut: TimeTrackingPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = TimeTrackingPresenter(view: view, stopwatchValueFormatter: stopwatchValueFormatter)
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
