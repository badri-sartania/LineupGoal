//
//  UltimateXIViewController.swift
//  GoalFury
//
//  Created by Morten Hansen on 13/06/2018.
//  Copyright © 2018 GoalFury. All rights reserved.
//

import UIKit

class UltimateXIViewController: UIViewController {
    
    @objc static func controller() -> UltimateXIViewController {
        return (UIStoryboard.init(name: "UltimateXI", bundle: nil).instantiateViewController(withIdentifier: "UltimateXIViewController") as? UltimateXIViewController)!
    }
    
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var vibrancyView: UIVisualEffectView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var ultimateLineupView: UltimateLineupView!
    @IBOutlet weak var totalScoreLabel: UILabel!
    var refreshControl = UIRefreshControl()
    var dataProvider = UltimateXIDataProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView = tableHeaderView
        tableView.registerCellClass(PlayerMatchStatsTableViewCell.self)
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
        
        ultimateLineupView.delegate = self
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if dataProvider.data.leaderboard.count == 0 {
            refreshData()
        }
    }
    
    func refreshData(){

        dataProvider.fetchData { (error) in
            self.refreshControl.endRefreshing()
            
            self.tableView.reloadData()
            self.ultimateLineupView.updatePlayers(self.dataProvider.data.leaderboard)
            
            let scoreString = NSMutableAttributedString(string: "Total ", attributes: [NSAttributedStringKey.font : UIFont.helvetica(size: 20)])
            scoreString.append(NSAttributedString(string: "\(self.dataProvider.data.totalPoints)p", attributes: [NSAttributedStringKey.font : UIFont.helveticaBold(size: 20)]))
            scoreString.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.darkGreyBlueTwo], range: NSRangeFromString(scoreString.string))
            
            self.totalScoreLabel.attributedText = scoreString

            if (self.dataProvider.data.leaderboard.count > 0) {
                self.hideBlur(animated: true)
            } else{
                if error != nil {
                    self.hideBlur(animated: true)
                } else{
                    self.showExplanationLabel(show: true, animated: true)
                }
            }
        }
    }
    
    func hideBlur(animated: Bool) {
        UIView.animate(withDuration: animated ? 0.5 : 0) {
            self.blurView.effect = nil
        }
        showExplanationLabel(show: false, animated: animated)
    }
    
    func showExplanationLabel(show: Bool, animated: Bool){
        UIView.animate(withDuration: animated ? 0.5 : 0) {
            self.vibrancyView.isHidden = !show
        }
    }
    
    @objc func didPullToRefresh() {
        refreshControl.beginRefreshing()
        refreshData()
    }
    
    @IBAction func didTapInfo(_ sender: Any) {
    }
}

extension UltimateXIViewController: UltimateLineupViewDelegate {
    func ultimateLinupView(_ view: UltimateLineupView, didSelectPlayer ultimateXIPlayer: UltimateXIPlayer) {
        let player = Player.initWithId(ultimateXIPlayer._id)
        let playerViewController = PlayerViewController.initWith(player)!
        let defaultNav = DefaultNavigationController(rootViewController: playerViewController)
        defaultNav.navigationBar.isHidden = true
        present(defaultNav, animated: true, completion: nil)
    }
}
