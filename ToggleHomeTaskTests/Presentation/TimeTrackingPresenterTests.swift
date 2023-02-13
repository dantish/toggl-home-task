//
//  TimeTrackingPresenterTests.swift
//  ToggleHomeTaskTests
//
//  Created by Daniel Tischenko on 13.02.2023.
//

import XCTest

final class TimeTrackingPresenter {

}

final class TimeTrackingPresenterTests: XCTestCase {

    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: TimeTrackingPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = TimeTrackingPresenter()
        return (sut, view)
    }

    private class ViewSpy {
        enum Message {

        }
        
        let messages: [Message] = []
    }

}
