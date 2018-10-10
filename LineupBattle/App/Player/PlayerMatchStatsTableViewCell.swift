//
//  PlayerMatchStatsTableViewCell.swift
//  GoalFury
//
//  Created by Morten Hansen on 19/06/2018.
//  Copyright © 2018 GoalFury. All rights reserved.
//

import UIKit

class PlayerMatchStatsTableViewCell: UITableViewCell, UITableViewCellNibLoadable {
    
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var vsLabel: UILabel!
    @IBOutlet weak var stageLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var badgeLabel: UILabel!
    
    func updateCell(player: UltimateXIPlayer){
//        scoreLabel.text = player.points == 0 ? nil : "\(player.points)p"
        
    }
}
