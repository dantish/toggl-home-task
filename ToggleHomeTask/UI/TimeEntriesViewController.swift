//
//  TimeEntriesViewController.swift
//  ToggleHomeTask
//
//  Created by Daniel Tischenko on 13.02.2023.
//

import UIKit

final class TimeEntriesViewController: UITableViewController, TimeEntriesView, TimeEntriesLoadingView {
    private var tableModel = [TimeEntryViewModel]() {
        didSet { tableView.reloadData() }
    }

    var onRefresh: (() -> Void)?
    var onRemove: ((Int) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        refresh()
    }

    @objc private func refresh() {
        onRefresh?()
    }

    public func display(_ viewModels: [TimeEntryViewModel]) {
        tableModel = viewModels
    }

    public func display(_ viewModel: TimeEntriesLoadingViewModel) {
        viewModel.isLoading
            ? tableView.refreshControl?.beginRefreshing()
            : tableView.refreshControl?.endRefreshing()
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        UISwipeActionsConfiguration(actions: [
            UIContextualAction(style: .destructive, title: "Remove") { [weak self] _,_,_ in
                self?.onRemove?(indexPath.row)
            }
        ])
    }
}
