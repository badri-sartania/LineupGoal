//
//  WalletTests.swift
//  LineupBattle
//
//  Created by Anders Hansen on 21/09/15.
//  Copyright © 2015 Pumodo. All rights reserved.
//

import XCTest
import YLMoment

class WalletSetCreditsTests: XCTestCase {
	var wallet = Wallet.init()
	let newDate = Date.init()
	let oldDate = YLMoment.now().addAmountOfTime(-10, forCalendarUnit:Calendar.Unit.Day).date()
	let nsdefault = UserDefaults.standard

	override func setUp() {
		super.setUp()

		// Clear wallet after each try
		UserDefaults.standard.removeObject(forKey: "wallet")
		wallet = Wallet.init()
	}

	func assertWalletValues(_ credits: Int?, date: Date?) {
		XCTAssertEqual(wallet.credits, credits)
		XCTAssertEqual(wallet.date, date)
	}

	func testWalletStandards() {
		assertWalletValues(nil, date: nil)
	}

	func testWalletFirstAdd() {
		wallet.setCredits(100, timestamp: newDate)
		assertWalletValues(100, date: newDate)
	}

	func testWalletAddValueWithOlderDate() {
		wallet.setCredits(100, timestamp: newDate)
		wallet.setCredits(200, timestamp: oldDate)

		assertWalletValues(100, date: newDate)
	}

	func testWalletAddValueWithNewerDate() {
		wallet.setCredits(100, timestamp: oldDate)
		wallet.setCredits(200, timestamp: newDate)

		assertWalletValues(200, date: newDate)
	}

	func testWalletDontCorruptWithNilValues() {
		wallet.setCredits(0, timestamp: nil)
		assertWalletValues(0, date: nil)

		let persistedWallet = (nsdefault.object(forKey: "wallet") as? [String: AnyObject])!
		let credits = persistedWallet["credits"] as? Int
		let date = persistedWallet["date"] as? Date

		XCTAssertEqual(credits, 0)
		XCTAssertNil(date)
	}

	func testWalletPersists() {
		wallet.setCredits(100, timestamp: newDate)

		let persistedWallet = (nsdefault.object(forKey: "wallet") as? [String: AnyObject])!
		let credits = persistedWallet["credits"] as? Int
		let date = persistedWallet["date"] as? Date

		XCTAssertEqual(credits, 100)
        XCTAssert(((date? == newDate) != nil))
	}
}
