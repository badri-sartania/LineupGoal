//
//  LeaderboardHelpViewController.swift
//  LineupBattle
//
//  Created by Anders Borre Hansen on 25/02/16.
//  Copyright © 2016 Pumodo. All rights reserved.
//

import UIKit
import TZStackView
import SnapKit

class LeaderboardHelpViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)

        self.navigationItem.title = "Help"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Done", style: .plain, target:self, action:#selector(LeaderboardHelpViewController.closeAction))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func closeAction () {
        self.navigationController!.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white

        let image1 = DefaultImageView.init(image: UIImage.init(named: "monthly_leaderboard"))
        let headline1 = DefaultLabel.initWithCenterText("MONTHLY LEADERBOARD")
        let text1  = DefaultLabel.initWithCenterText("Every month fans battle on who’s the best in getting most points for all battles and who made the best lineup. It’s divided up in three categories: Global, country and friends.")

        let image2 = DefaultImageView.init(image: UIImage.init(named: "global_leaderboard"))
        let headline2 = DefaultLabel.initWithCenterText("Global")
        let text2 = DefaultLabel.initWithCenterText("Here you’re ranked against everybody else in the app.")

        let image3 = DefaultImageView.init(image: UIImage.init(named: "uk_leaderboard"))
        let headline3 = DefaultLabel.initWithCenterText("Country")
        let text3 = DefaultLabel.initWithCenterText("Only ranked against your countrymen.")

        let image4 = DefaultImageView.init(image: UIImage.init(named: "friends_leaderboard"))
        let headline4 = DefaultLabel.initWithCenterText("Friends")
        let text4 = DefaultLabel.initWithCenterText("Only against your Facebook friends who have connected with Facebook in Lineup Battle.")

        headline1!.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.medium)
        headline2!.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        headline3!.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        headline4!.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)

        text1!.numberOfLines = 0
        text2!.numberOfLines = 0
        text3!.numberOfLines = 0
        text4!.numberOfLines = 0

        image1.contentMode = .center
        image2.contentMode = .center
        image3.contentMode = .center
        image4.contentMode = .center

        let textWidth = 280

        headline1!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(textWidth)
        }

        headline2!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(textWidth)
        }

        headline3!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(textWidth)
        }

        headline4!.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(textWidth)
        }

        let paragraf1 = TZStackView.init(arrangedSubviews: [image1, headline1!, text1!])
        let paragraf2 = TZStackView.init(arrangedSubviews: [image2, headline2!, text2!])
        let paragraf3 = TZStackView.init(arrangedSubviews: [image3, headline3!, text3!])
        let paragraf4 = TZStackView.init(arrangedSubviews: [image4, headline4!, text4!])

        let paragrafSpacing: CGFloat = 7


        paragraf1.spacing = paragrafSpacing
        paragraf1.axis = .vertical
        paragraf2.spacing = paragrafSpacing
        paragraf2.axis = .vertical
        paragraf3.spacing = paragrafSpacing
        paragraf3.axis = .vertical
        paragraf4.spacing = paragrafSpacing
        paragraf4.axis = .vertical

        let textStackView = TZStackView.init(arrangedSubviews: [paragraf1, paragraf2, paragraf3, paragraf4])
        textStackView.spacing = 30
        textStackView.axis = .vertical

        let scrollView = UIScrollView.init()
        scrollView.isScrollEnabled = true
        self.view.addSubview(scrollView)

        scrollView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }

        let contentView = UIView.init()
        scrollView.addSubview(contentView)
        contentView.addSubview(textStackView)
        contentView.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(scrollView).offset(-30)
            make.top.bottom.equalTo(scrollView).offset(30)
            make.centerX.equalTo(self.view)
            make.width.equalTo(textWidth)
        }

        textStackView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView)
        }

        contentView.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(textStackView.snp.bottom)
        }
    }
}
