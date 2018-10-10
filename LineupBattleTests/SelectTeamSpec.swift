//
//  TeamPlayerSorterTests.swift
//  LineupBattle
//
//  Created by Anders Hansen on 18/09/15.
//  Copyright © 2015 Pumodo. All rights reserved.
//

import Quick
import Nimble

class SelectTeamHelperSpec: QuickSpec {
    override func spec() {
        describe("playerToPositionDictionary") {
            let teams: [Team] = [
                Team.dictionaryTransformer([
                    "_id": "abc",
                    "name": "abc club",
                    "players": [
                        [ "_id": "id1", "position": "gk" ],
                        [ "_id": "id2", "position": "fw" ],
                        [ "_id": "id3", "position": "fw" ],
                    ]
                ]) as Team,
                Team.dictionaryTransformer([
                    "_id": "abc",
                    "name": "abc club",
                    "players": [
                        [ "_id": "id1", "position": "gk" ],
                        [ "_id": "id2", "position": "mf" ],
                        [ "_id": "id3", "position": "mf" ],
                    ]
                ]) as Team
            ]

            it("should sort player into position arrays") {
                let players = (teams[0].players as? [Player])!
                let sortedPlayers = SelectTeamHelper.playerToPositionDictionary(players)
                expect(sortedPlayers.keys.count).to(equal(2))
                expect(sortedPlayers["gk"]?.count).to(equal(1))
                expect(sortedPlayers["fw"]?.count).to(equal(2))
            }
        }
    }
}
