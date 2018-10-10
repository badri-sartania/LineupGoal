//
//  PointsCalculationSpec.swift
//  LineupBattle
//
//  Created by Anders Hansen on 07/10/15.
//  Copyright © 2015 Pumodo. All rights reserved.
//

import Quick
import Nimble

class PointsCalculationSpec: QuickSpec {
    override func spec() {
        let points = [
            ["_id": "player1", "points": 10],
            ["_id": "player1", "points": 50],
            ["_id": "player1", "points": -10],
            ["_id": "player2", "points": 100]
        ]

        let players = [
            Player.dictionaryTransformer(["_id": "player1"]),
            Player.dictionaryTransformer(["_id": "player2"])
        ]

        let pointsArray = PointsCalculation.pointsArrayForPlayer(players[0], points: points)

        describe("pointsArrayForPlayer") {
            it("should calculate correct") {
                expect(pointsArray.count).to(equal(3))
            }
        }

        describe("totalValueOfPoints") {
            it("should calculate correct") {
                let points = PointsCalculation.totalValueOfPoints(pointsArray)
                expect(points).to(equal(50))
            }
        }

        describe("pointsForPlayers") {
            it("should calculate correct") {
                let points = PointsCalculation.pointsForPlayers(players, points: points)
                expect(points).to(equal(150))
            }
        }
    }
}
