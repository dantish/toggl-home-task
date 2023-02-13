//
//  TimeEntriesViewController.swift
//  ToggleHomeTask
//
//  Created by Daniel Tischenko on 13.02.2023.
//

import UIKit

final class TimeEntriesViewController: UITableViewController {
    private var tableModel = [TimeEntryViewModel]() {
        didSet { tableView.reloadData() }
    }

    var onRefresh: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl

        refresh()
    }

    @objc private func refresh() {
        onRefresh?()
    }

    public func display(_ viewModels: [TimeEntryViewModel]) {
        tableModel = viewModels
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell = dequeuedCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }

        var configuration = UIListContentConfiguration.cell()
        configuration.text = tableModel[indexPath.row].title

        cell.contentConfiguration = configuration
        return cell
    }
}
