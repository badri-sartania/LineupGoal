//
//  LineupSpecHelperSpec.swift
//  LineupBattle
//
//  Created by Anders Hansen on 08/10/15.
//  Copyright © 2015 Pumodo. All rights reserved.
//

import Quick
import Nimble

class LineupSpecHelperSpec: QuickSpec {
    override func spec() {
        describe("generatePlayerWithPosition") {
            it("generate complete player") {
                let player = LineupSpecHelper().generatePlayer("gk", fieldIndex: 1)
                expect(player.name).to(equal("somename"))
                expect(player.position).to(equal("gk"))
                expect(player.fieldIndex).to(equal(1))
            }

            it("should accept nil value") {
                let player = LineupSpecHelper().generatePlayer("", fieldIndex: -1)
                expect(player.position).to(beNil())
                expect(player.fieldIndex).to(beNil())
            }
        }

        describe("generateLineupPlayers") {
            it("should generate correct lineup") {
                let lineup = LineupSpecHelper().generateLineup(5, midfielders: 5, forwards: 5)
                expect(lineup.count).to(equal(16))
                expect(lineup[0].position).to(equal("gk"))
                expect(lineup[1].position).to(equal("df"))
                expect(lineup[6].position).to(equal("mf"))
                expect(lineup[11].position).to(equal("fw"))
            }
        }
    }
}
