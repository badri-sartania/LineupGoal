//
//  StandardTableViewController.swift
//  LineupBattle
//
//  Created by Anders Borre Hansen on 26/11/15.
//  Copyright © 2015 Pumodo. All rights reserved.
//

import UIKit
import StatefulViewController
import SnapKit

protocol StardardFetching {
    func fetchData(_ dataCompletion: @escaping (_ data: [AnyObject]) -> Void, errorCompletion: @escaping (_ error: NSError) -> Void)
}

extension BackingViewProvider where Self: StandardTableViewController {
    internal var backingView: UIView {
        return tableView
    }
}

class StandardTableViewController: UIViewController, StatefulViewController, StardardFetching, UITableViewDataSource, UITableViewDelegate {
    var dataArray: Array<AnyObject> = []
    let refreshControl = UIRefreshControl()
    let tableView: UITableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
                tableView.separatorStyle = .none
        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }

        // MARK: Setup refresh control
        refreshControl.addTarget(self, action: #selector(StandardTableViewController.refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)

        // MARK: Setup placeholder views
        if loadingView == nil {
            loadingView = LoadingView(frame: view.frame)
        }

        if emptyView == nil {
            emptyView = EmptyView(frame: view.frame)
        }

        if errorView == nil {
            let failureView = ErrorView(frame: view.frame)
            failureView.tapGestureRecognizer.addTarget(self, action: #selector(StandardTableViewController.refresh))
            errorView = failureView
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self.tableView.indexPathForSelectedRow != nil {
            self.tableView.deselectRow(at: self.tableView.indexPathForSelectedRow!, animated: true)
        }

        setupInitialViewState()
        refresh()
    }

    // MARK: Stateful Handling
    @objc func refresh() {
        if lastState == .Loading {
            return
        }

        startLoading()

        fetchData({ (data) -> Void in
            self.dataArray = data
            self.endLoading(error: nil, completion: nil)
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }) { (error) -> Void in
            self.endLoading(error: error, completion: nil)
            self.refreshControl.endRefreshing()
        }
    }

    func hasContent() -> Bool {
        return dataArray.count > 0
    }

    // MARK: Data function
    func fetchData(_ dataCompletion: @escaping (_ data: [AnyObject]) -> Void, errorCompletion: @escaping (_ error: NSError) -> Void) {
        assert(true, "not implemented in subclass")
    }

    // MARK: Default Delegates
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 33
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.init()
    }
}
