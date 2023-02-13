//
//  TimeTrackingViewController.swift
//  ToggleHomeTask
//
//  Created by Daniel Tischenko on 13.02.2023.
//

import UIKit

final class TimeTrackingViewController: UIViewController, TimeTrackingView {
    @IBOutlet weak var stopwatchLabel: UILabel!
    @IBOutlet weak var toggleButton: UIButton!

    var onViewLoaded: (() -> Void)?
    var onStopwatchToggled: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        stopwatchLabel.font = .boldSystemFont(ofSize: 72)

        toggleButton.configuration = .filled()
        toggleButton.configuration?.cornerStyle = .capsule

        onViewLoaded?()
    }

    func display(_ viewModel: TimeTrackingViewModel) {
        stopwatchLabel.text = viewModel.stopwatchValue

        toggleButton.configuration?.attributedTitle = AttributedString(viewModel.toggleActionTitle, attributes: AttributeContainer([
            .font: UIFont.boldSystemFont(ofSize: 24)
        ]))

        toggleButton.configuration?.baseBackgroundColor = viewModel.isToggleActionDestructive
            ? .systemRed
            : .systemBlue
    }

    @IBAction func switchButtonTapped(_ sender: Any) {
        onStopwatchToggled?()
    }
}
