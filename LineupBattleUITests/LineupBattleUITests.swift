//
//  LineupBattleUITests.swift
//  LineupBattleUITests
//
//  Created by Anders Hansen on 02/10/15.
//  Copyright © 2015 Pumodo. All rights reserved.
//

import XCTest

class LineupBattleUITests: XCTestCase {

    override func setUp() {
        super.setUp()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        let app = XCUIApplication.init()
        app.launchEnvironment = ["isUITest": "yes"]
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testExample() {
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        let leaderboardButton = tabBarsQuery.buttons["Leaderboards"]
        leaderboardButton.tap()

        let gamesButton = tabBarsQuery.buttons["Games"]
        gamesButton.tap()

        let moreButton = tabBarsQuery.buttons["More"]
        moreButton.tap()
        tabBarsQuery.buttons["Battles"].tap()
        app.tables.buttons["profileImageButton"].tap()

        let profileNavigationBar = app.navigationBars["Profile"]
        profileNavigationBar.buttons["Edit"].tap()

        let editUserNavigationBar = app.navigationBars["Edit User"]
        editUserNavigationBar.buttons["Back"].tap()
        profileNavigationBar.buttons["Close"].tap()
        leaderboardButton.tap()
        gamesButton.tap()
        moreButton.tap()
    }
}
