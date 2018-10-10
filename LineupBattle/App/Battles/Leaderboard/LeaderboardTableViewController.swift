//
//  LeaderboardTableViewController.swift
//  LineupBattle
//
//  Created by Anders Borre Hansen on 17/11/15.
//  Copyright © 2015 Pumodo. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import TZStackView
import SwiftDate

class LeaderboardTableViewController: StandardTableViewController, FBSDKLoginButtonDelegate {
    var leaderboardIndex = 0
    var leaderboardNames = ["World", "Country", "Friends"]
    let leaderboardObjects: [AnyObject]? = [
        UIImage.init(named: "battle_globe")!, "" as AnyObject,
        UIImage.init(named: "battle_persons")!
    ]
    var segmentedControl: UISegmentedControl?
    let monthLabel = DefaultLabel.initWithCenterText("")
    var buttonBorder: UIView?
    var currentTab = 1
    var currentDate = Date()
    let rightButton = UIButton.init(type: .custom)
    let leftButton = UIButton.init(type: .custom)
    let endedLabel = DefaultLabel.initWithCenterText("Ended")
    //    let countDownDate = Date().endOf(.Month, inRegion: DateInRegion(timeZoneName: TimeZoneName.Gmt))
    let countDownDate = Date().endOf(component: .month)
    let totalButton = UIButton.init(type: .custom)
    let lineupButton = UIButton.init(type: .custom)
    let countdownLabel = DefaultLabel.initWithCenterText("")
    var timer: Timer?
    init() {
        super.init(nibName: nil, bundle: nil)
        navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        segmentedControl = UISegmentedControl(items: leaderboardObjects)
        segmentedControl!.selectedSegmentIndex = 0
        segmentedControl!.tintColor = UIColor.action()
        segmentedControl!.addTarget(self, action: #selector(LeaderboardTableViewController.segmentedValueChanged(_:)), for: .valueChanged)
        segmentedControl!.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)], for: UIControlState())
        let infoButton = UIButton.init(type: .infoLight)
        infoButton.addTarget(self, action: #selector(LeaderboardTableViewController.infoButtonPressed), for: .touchUpInside)
        self.navigationItem.titleView = segmentedControl
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: infoButton)
        tableView.register(LeaderboardTableViewCell.self, forCellReuseIdentifier: "leaderboardViewCell")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(LeaderboardTableViewController.timerUpdate), userInfo: nil, repeats: true)
        timerUpdate()
        Answers.logCustomEvent(withName: "Leaderboard", customAttributes: [
            "type": leaderboardNames[leaderboardIndex]
            ])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        emptyView = NoLeaderboardEntriesPlaceholderView()
        let headerHeight: CGFloat = 110
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.applicationFrame.size.width, height: headerHeight))
        view.addSubview(headerView)
        // Calendar
        monthLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
        monthLabel?.text = monthString(YLMoment(date: currentDate))
        leftButton.setImage(UIImage.init(named: "arrow_left"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(LeaderboardTableViewController.calendarButtonPressed(_:)), for: .touchUpInside)
        leftButton.tag = 1
        leftButton.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(30)
        }
        rightButton.setImage(UIImage.init(named: "arrow_right"), for: UIControlState())
        rightButton.addTarget(self, action: #selector(LeaderboardTableViewController.calendarButtonPressed(_:)), for: .touchUpInside)
        rightButton.tag = 2
        rightButton.isEnabled = false
        rightButton.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(30)
        }
        let calendarStack = TZStackView.init(arrangedSubviews: [leftButton, monthLabel!, rightButton])
        calendarStack.alignment = .center
        calendarStack.spacing = 10
        countdownLabel?.font = UIFont.systemFont(ofSize: 13)
        countdownLabel?.textColor = UIColor.darkGrayText()
        let stackView = TZStackView.init(arrangedSubviews: [calendarStack, countdownLabel!])
        stackView.axis = .vertical
        stackView.spacing = 0
        headerView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(headerView).offset(15)
            make.centerX.equalTo(headerView)
        }
        totalButton.setTitle("Best Total", for: UIControlState())
        totalButton.tag = 1
        totalButton.setTitleColor(UIColor.action(), for: UIControlState())
        lineupButton.setTitle("Best Lineup", for: UIControlState())
        lineupButton.tag = 2
        lineupButton.setTitleColor(UIColor.grayIcon(), for: UIControlState())
        totalButton.addTarget(self, action: #selector(LeaderboardTableViewController.buttonSelection(_:)), for: .touchUpInside)
        lineupButton.addTarget(self, action: #selector(LeaderboardTableViewController.buttonSelection(_:)), for: .touchUpInside)
        headerView.addSubview(totalButton)
        headerView.addSubview(lineupButton)
        totalButton.snp.makeConstraints { (make) -> Void in
            make.left.bottom.equalTo(headerView)
            make.height.equalTo(40)
            make.width.equalTo(Utils.screenWidth()/2)
        }
        lineupButton.snp.makeConstraints { (make) -> Void in
            make.right.bottom.equalTo(headerView)
            make.height.equalTo(40)
            make.width.equalTo(Utils.screenWidth()/2)
        }
        // Button Selector
        let buttonSelectedBorderRect = CGRect(x: 0, y: headerView.frame.height - 3, width: headerView.frame.width/2, height: 3)
        buttonBorder = UIView.init(frame: buttonSelectedBorderRect)
        buttonBorder!.backgroundColor = UIColor.action()
        headerView.addSubview(buttonBorder!)
        // Button gray border
        let bottomBorderRect = CGRect(x: 0, y: headerView.frame.height, width: headerView.frame.width, height: 1/UIScreen.main.scale)
        let bottomBorder = UIView.init(frame: bottomBorderRect)
        bottomBorder.backgroundColor = UIColor.black
        bottomBorder.alpha = 0.25
        headerView.addSubview(bottomBorder)
        tableView.snp.remakeConstraints { (make) -> Void in
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(headerHeight, 0, 0, 0))
        }
    }
    // MARK: Timer update
    @objc func timerUpdate() {
        let diffDate = self.differenceInDaysWithDate(countDownDate)
        let dayString = diffDate.day! < 10 ? "0\(diffDate.day ?? 0)" : "\(diffDate.day ?? 0)"
        let hourString = diffDate.hour! < 10 ? "0\(diffDate.hour ?? 0)" : "\(diffDate.hour ?? 0)"
        let minuteString = diffDate.minute! < 10 ? "0\(diffDate.minute ?? 0)" : "\(diffDate.minute ?? 0)"
        let diffString = "Ends in \(dayString)d \(hourString)h \(minuteString)m"
        countdownLabel?.text = diffString
    }
    // MARK: Actions
    @objc func segmentedValueChanged(_ sender: UISegmentedControl) {
        leaderboardIndex = sender.selectedSegmentIndex
        let name = leaderboardNames[leaderboardIndex]
//        Answers.logCustomEvent(withName: "Leaderboard", customAttributes: [
//            "type": name
//            ])
        self.startLoading()
        self.tableView.reloadData()
        self.endLoading()
    }
    @objc func buttonSelection(_ sender: UIButton) {
        let halfWidth = Utils.screenWidth() / 2
        self.currentTab = sender.tag // 1 or 2
        self.tableView.reloadData()
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations: {
            let originX = self.buttonBorder!.frame.origin.x
            if originX == 0 && sender.tag == 2 {
                self.buttonBorder!.frame.origin.x += halfWidth
                self.lineupButton.setTitleColor(UIColor.action(), for: UIControlState())
                self.totalButton.setTitleColor(UIColor.grayIcon(), for: UIControlState())
            } else if originX == halfWidth && sender.tag == 1 {
                self.buttonBorder!.frame.origin.x -= halfWidth
                self.lineupButton.setTitleColor(UIColor.grayIcon(), for: UIControlState())
                self.totalButton.setTitleColor(UIColor.action(), for: UIControlState())
            }
        }, completion: { finished in })
    }
    @objc func infoButtonPressed() {
        let navigationController = DefaultNavigationController.init(rootViewController: LeaderboardHelpViewController.init())
        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }
    @objc func calendarButtonPressed(_ sender: UIButton) {
        let monthMoment: YLMoment
        // Sender == 1 == Next Month
        if sender.tag == 1 {
            monthMoment = YLMoment(date: currentDate).subtractAmount(ofTime: 1, forUnitKey: "M")
            rightButton.isEnabled = true
            if monthMoment.year == 2015 && monthMoment.month == 10 {
                leftButton.isEnabled = false
            }
        } else {
            monthMoment = YLMoment(date: currentDate).addAmount(ofTime: 1, forUnitKey: "M")
            leftButton.isEnabled = true
            if monthMoment.month == YLMoment().month && monthMoment.year == YLMoment().year {
                rightButton.isEnabled = false
            }
        }
        monthLabel?.text = monthString(monthMoment)
        currentDate = monthMoment.date()
        self.refresh()
    }
    // MARK: Data Handling
    override func fetchData(_ dataCompletion: @escaping ([AnyObject]) -> Void, errorCompletion: @escaping (NSError) -> Void) {
        LineupBattleResource.leaderboards(forMonth: generateMonthString(currentDate), success: { (leaderboards) -> Void in
            dataCompletion(leaderboards!)
            let countryLeaderboard = leaderboards?.filter({ (leaderboard) -> Bool in
                return leaderboard.country != nil
            })
            if countryLeaderboard!.count > 0 {
                self.segmentedControl?.setTitle(countryLeaderboard![0].country, forSegmentAt: 1)
                let countryName = CountryCodeHelper.isoAlpha2Code(toName: countryLeaderboard![0].country)
                self.leaderboardNames[1] = countryName!
            }
        }, failure: { (dataError) -> Void in
            errorCompletion(dataError! as NSError)
        })
    }
    // MARK: Data Helpers
    func leaderboard() -> Leaderboard? {
        if dataArray.count == 0 { return nil }
        return (dataArray[leaderboardIndex] as? Leaderboard)!
    }
    func leaderboardUserCount() -> Int {
        if let board = leaderboard() {
            return currentTab == 1 ? board.total.count : board.lineup.count
        }
        return 0
    }
    func userForLeaderboardIndexPath(_ indexPath: NSIndexPath) -> User {
        if currentTab == 1 {
            return (leaderboard()?.total[indexPath.row] as? User)!
        } else {
            return (leaderboard()?.lineup[indexPath.row] as? User)!
        }
    }
    func showFacebookLogin() -> Bool {
        return leaderboardIndex == 2 && leaderboardUserCount() <= 1 && FBSDKAccessToken.current() == nil
    }
    override func hasContent() -> Bool {
        if leaderboard() == nil {
            return false
        }
        return leaderboard()!.total.count > 0 || leaderboard()!.lineup.count > 0
    }
    // MARK: Table Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showFacebookLogin() { return 1 }
        if leaderboard() != nil { return leaderboardUserCount() }
        return 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if showFacebookLogin() {
            let cell = FBSDKLoginButtonHelper.loginWithFacebookViewCell(withTopText: "See how your friends are doing by connecting with Facebook.", withDelegate: self)
            return cell!
        } else {
            let cell: LeaderboardTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "leaderboardViewCell", for: indexPath) as? LeaderboardTableViewCell)!
//            cell.setUser(userForLeaderboardIndexPath(indexPath as NSIndexPath))
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.init()
    }
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        if showFacebookLogin() { return 170 }
        return 65
    }
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        if showFacebookLogin() { return }
        let user = userForLeaderboardIndexPath(indexPath as NSIndexPath)
        let controller = ProfileTableViewController.init(profileId: user.objectId)
        self.navigationController?.pushViewController(controller!, animated: true)
    }
    // MARK: FBLogin Delegate
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        FBSDKLoginButtonHelper.registerFacebookLogin(result) { () -> Void in
            self.tableView.reloadData()
//            Answers.logLogin(withMethod: "Facebook", success: true, customAttributes: [
//                "location": "Friend leaderboard"
//                ])
            self.tableView.reloadData()
        }
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {}
    // MARK: Helpers
    func generateMonthString(_ date: Date) -> String {
        let component = Calendar.current.dateComponents([.month, .year], from: date)
        let year = component.year
        let month = component.month
        if month! < 10 {
            return String(describing: year) + "0" + String(describing: month)
        }
        return String(describing: year) + String(describing: month)
    }
    func monthString(_ moment: YLMoment) -> String {
        let monthName: String
        if moment.year != YLMoment().year {
            monthName = moment.format("MMMM YYYY")
        } else {
            monthName = moment.format("MMMM")
        }
        return monthName + " Leaderboard"
    }
    func differenceInDaysWithDate(_ date: Date) -> DateComponents {
        let calendar: Calendar = Calendar.current
        // let components = calendar.dateComponents([.day, .hour, .minute], fromDate: Date(), toDate: countDownDate, options: [])
        let components = calendar.dateComponents([.day, .hour, .minute], from: Date(), to: countDownDate)
        return components
    }
}

