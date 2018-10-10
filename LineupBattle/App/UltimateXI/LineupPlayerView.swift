//
//  LineupPlayerView.swift
//  GoalFury
//
//  Created by Morten Hansen on 17/06/2018.
//  Copyright © 2018 GoalFury. All rights reserved.
//

import UIKit

protocol LineupPlayerViewDelegate : NSObjectProtocol {
    func didTapLineupPlayerView(_ view: LineupPlayerView)
}

class LineupPlayerView: NibView {
    
    @IBOutlet weak var playerImageView: DefaultImageView!
    @IBOutlet weak var newImageView: UIImageView!
    @IBOutlet weak var ballImageView: UIImageView!
    @IBOutlet weak var goalNumberView: UIView!
    @IBOutlet weak var goalNumberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var clubLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    
    var player : UltimateXIPlayer?
    var delegate: LineupPlayerViewDelegate?
    
    func update(_ player : UltimateXIPlayer?){
        self.player = player
        if let player = player{
            newImageView.isHidden = !player.new
            goalNumberView.isHidden = player.goals < 2
            goalNumberLabel.text = "\(player.goals)"
            ballImageView.isHidden = player.goals == 0
            playerImageView.setPlayerImage(id: player._id)
            nameLabel.text = player.name
            clubLabel.text = player.nationality
            pointLabel.text = "\(player.points)p"
        } else{
            newImageView.isHidden = true
            goalNumberView.isHidden = true
            ballImageView.isHidden = true
            playerImageView.image = nil
            nameLabel.text = nil
            clubLabel.text = nil
            pointLabel.text = nil
        }
    }
    @IBAction func didPressLineupView(_ sender: Any) {
        delegate?.didTapLineupPlayerView(self)
    }
}
