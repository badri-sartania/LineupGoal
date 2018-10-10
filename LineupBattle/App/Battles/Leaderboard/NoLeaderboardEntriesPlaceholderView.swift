//
//  NoLeaderboardEntriesPlaceholderView.swift
//  LineupBattle
//
//  Created by Anders Borre Hansen on 25/02/16.
//  Copyright © 2016 Pumodo. All rights reserved.
//

import UIKit
import SnapKit
import HexColors

class NoLeaderboardEntriesPlaceholderView: BasicPlaceholderView {
    let imageView = UIImageView()
    let textLabel = DefaultLabel.initWithCenterText("Once the first monthly battle has been played the leaderboard will be updated")

    override func setupView() {
        let yOffset = 40
        textLabel!.numberOfLines = 0
        textLabel!.textColor = UIColor.hx_color(withHexString: "#bbc3c7")
        textLabel!.font = UIFont.systemFont(ofSize: 15)
        imageView.image = UIImage.init(named: "leaderboard_placeholder")

        self.addSubview(textLabel!)
        self.addSubview(imageView)

        imageView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-yOffset)
            make.width.equalTo(121)
            make.height.equalTo(108)
        }
        
        textLabel!.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(yOffset+20)
            make.width.equalTo(Utils.screenWidth()*0.6)
        }
    }
}
