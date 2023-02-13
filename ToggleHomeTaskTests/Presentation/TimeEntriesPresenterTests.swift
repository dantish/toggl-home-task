//
//  TimeEntriesPresenterTests.swift
//  ToggleHomeTaskTests
//
//  Created by Daniel Tischenko on 13.02.2023.
//

import XCTest

final class TimeEntriesPresenter {

}

final class TimeEntriesPresenterTests: XCTestCase {

    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: TimeEntriesPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = TimeEntriesPresenter()
        return (sut, view)
    }

    private class ViewSpy {
        enum Message: Hashable {
        }

        let messages: [Message] = []
    }

}
