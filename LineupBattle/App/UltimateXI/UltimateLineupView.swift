//
//  UltimateLineupView.swift
//  GoalFury
//
//  Created by Morten Hansen on 13/06/2018.
//  Copyright © 2018 GoalFury. All rights reserved.
//

import UIKit

protocol UltimateLineupViewDelegate: NSObjectProtocol {
    func ultimateLinupView(_ view: UltimateLineupView, didSelectPlayer ultimateXIPlayer: UltimateXIPlayer)
}

class UltimateLineupView: NibView {
    
    @IBOutlet weak var goalKeeperView: LineupPlayerView!
    @IBOutlet weak var leftDefenderView: LineupPlayerView!
    @IBOutlet weak var middleDefenderView: LineupPlayerView!
    @IBOutlet weak var rightDefenderView: LineupPlayerView!
    @IBOutlet weak var firstMidfieldView: LineupPlayerView!
    @IBOutlet weak var secondMidfieldView: LineupPlayerView!
    @IBOutlet weak var thirdMidfieldView: LineupPlayerView!
    @IBOutlet weak var fourthMidfieldView: LineupPlayerView!
    @IBOutlet weak var leftAttackerView: LineupPlayerView!
    @IBOutlet weak var middleAttackerView: LineupPlayerView!
    @IBOutlet weak var rightAttackerView: LineupPlayerView!
    
    var playerViews = [LineupPlayerView]()
    var defenderViews = [LineupPlayerView]()
    var midfielderViews = [LineupPlayerView]()
    var attackerViews = [LineupPlayerView]()
    
    weak var delegate: UltimateLineupViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        playerViews = [goalKeeperView, leftDefenderView, middleDefenderView, rightDefenderView, firstMidfieldView, secondMidfieldView, thirdMidfieldView, fourthMidfieldView, leftAttackerView, middleAttackerView, rightAttackerView]
        for playerView in playerViews {
            playerView.delegate = self
        }
        
        defenderViews = [leftDefenderView, middleDefenderView, rightDefenderView]
        midfielderViews = [firstMidfieldView, secondMidfieldView, thirdMidfieldView, fourthMidfieldView]
        attackerViews = [leftAttackerView, middleAttackerView, rightAttackerView]
    }
    
    func updatePlayers(_ players: [UltimateXIPlayer]){
        let goalKeeper = players.filter{$0.position == .goalKeeper}.first
        let defenders = players.filter{$0.position == .defender}.prefix(3)
        let midfielders = players.filter{$0.position == .midfielder}.prefix(4)
        let attackers = players.filter{$0.position == .forward}.prefix(3)
        
        goalKeeperView.update(goalKeeper)
        
        for (index,defenderView) in defenderViews.enumerated(){
            let player = index < defenders.count ? defenders[index] : nil
            defenderView.update(player)
        }
        
        for (index, playerView) in midfielderViews.enumerated(){
            let player = index < midfielders.count ? midfielders[index] : nil
            playerView.update(player)
        }

        for (index, playerView) in attackerViews.enumerated(){
            let player = index < attackers.count ? attackers[index] : nil
            playerView.update(player)
        }
    }
}

extension UltimateLineupView : LineupPlayerViewDelegate {
    func didTapLineupPlayerView(_ view: LineupPlayerView){
        if let player = view.player{
            delegate?.ultimateLinupView(self, didSelectPlayer: player)
        }
    }
}
