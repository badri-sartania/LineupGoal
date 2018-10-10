//
//  LineupSpec.swift
//  LineupBattle
//
//  Created by Anders Hansen on 07/10/15.
//  Copyright © 2015 Pumodo. All rights reserved.
//

import Quick
import Nimble

class LineupSpec: QuickSpec {
    override func spec() {
        describe("Class functions") {
            let formation = [2, 3, 2]
            describe("Lineup.withPlayers: formation:") {
                let players = LineupSpecHelper().generateLineup(2, midfielders: 3, forwards: 2)
                let lineup = Lineup.withPlayers(players, formation: formation)

                it ("should generate lineup correctly") {
                    LineupSpecHelper().verifyLineup(lineup)
                }

                it ("should order players correctly") {
                    let shuffledPlayers = players.shuffle()
                    let lineup  = Lineup.withPlayers(shuffledPlayers, formation: formation)

                    LineupSpecHelper().verifyLineup(lineup)
                }

                it ("should filter out invalid players") {
                    var playersPlusInvalid = players
                    playersPlusInvalid.append(Player.dictionaryTransformer([
                        "name": "invalid person",
                    ]))
                    playersPlusInvalid.append(Player.dictionaryTransformer([
                        "name": "invalid person",
                        "position": "mf"
                    ]))
                    playersPlusInvalid.append(Player.dictionaryTransformer([
                        "name": "invalid person",
                        "fieldIndex": 17
                    ]))

                    let lineup = Lineup.withPlayers(playersPlusInvalid, formation: formation)

                    LineupSpecHelper().verifyLineup(lineup)
                }
            }

            describe("Lineup.filterPlayersWithFieldIndex:") {
                it ("should return all with field index") {
                    let players = LineupSpecHelper().generateLineup(2, midfielders: 3, forwards: 2)
                    expect(Lineup.playersWithFieldIndex(players).count).to(equal(8))
                }

                it ("should not return player without field index") {
                    let players = [
                        LineupSpecHelper().generatePlayer("gk", fieldIndex: -1),
                        LineupSpecHelper().generatePlayer("", fieldIndex: 1),
                        LineupSpecHelper().generatePlayer("fw", fieldIndex: 2)
                    ]

                    expect(Lineup.playersWithFieldIndex(players).count).to(equal(2))
                }
            }

            describe("Lineup.sortPlayersByFieldIndex:") {
                let players = [
                    LineupSpecHelper().generatePlayer("gk", fieldIndex: 2),
                    LineupSpecHelper().generatePlayer("mf", fieldIndex: 3),
                    LineupSpecHelper().generatePlayer("fw", fieldIndex: 1)
                ]

                let sortedPlayers = Lineup.sortPlayersByFieldIndex(players)

                expect(sortedPlayers.count).to(equal(3))
                expect(sortedPlayers[0].fieldIndex).to(equal(1))
                expect(sortedPlayers[1].fieldIndex).to(equal(2))
            }

            describe("Lineup.applyFieldIndexToLineup:") {
                it ("should remove non plaers") {
                    let players = [
                        LineupSpecHelper().generatePlayer("gk", fieldIndex: -1),
                        NSObject.init(),
                        LineupSpecHelper().generatePlayer("fw", fieldIndex: -1)
                    ]

                    let sortedPlayers = Lineup.applyFieldIndexToLineup(players)

                    expect(sortedPlayers.count).to(equal(3))
                    expect(sortedPlayers[0].fieldIndex).to(equal(0))
                    expect(sortedPlayers[2].fieldIndex).to(equal(1))
                }
            }

            describe("Lineup.emptyLineup") {
                let lineup = Lineup.emptyLineup()
                LineupSpecHelper().verifyLineupStructure(lineup as [AnyObject])
            }
        }
    }
}
