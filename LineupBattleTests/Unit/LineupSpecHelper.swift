//
//  LineupSpecHelper.swift
//  LineupBattle
//
//  Created by Anders Hansen on 07/10/15.
//  Copyright © 2015 Pumodo. All rights reserved.
//

import Quick
import Nimble

struct LineupSpecHelper {
    func generatePlayer(_ position: String, fieldIndex: Int) -> Player {
        var dic = [
            "name": "somename",
            "shirt": 1
        ]

        if fieldIndex != -1 {
            dic["fieldIndex"] = fieldIndex
        }

        if position != "" {
            dic["position"] = position
        }

        return Player.dictionaryTransformer(dic)
    }

    func generateLineup(_ defenders: Int, midfielders: Int, forwards: Int) -> [Player] {
        var fieldCount = 0
        var lineup = [
            generatePlayer("gk", fieldIndex: fieldCount++)
        ]

        for _ in 1...defenders {
            lineup.append(generatePlayer("df", fieldIndex: fieldCount++))
        }

        for _ in 1...midfielders {
            lineup.append(generatePlayer("mf", fieldIndex: fieldCount++))
        }

        for _ in 1...forwards {
            lineup.append(generatePlayer("fw", fieldIndex: fieldCount++))
        }

        return lineup
    }

    func verifyLineup (_ lineup: [AnyObject]) {
        LineupSpecHelper().verifyLineupStructure(lineup)
        LineupSpecHelper().verifyFieldIndex(lineup)
        LineupSpecHelper().verifyPosition(lineup)
    }

    func verifyLineupStructure(_ lineup: [AnyObject]) {
        expect(lineup.count).to(equal(4))
        expect(lineup[0].count).to(equal(1))
        expect(lineup[1].count).to(equal(2))
        expect(lineup[2].count).to(equal(3))
        expect(lineup[3].count).to(equal(2))
    }

    func verifyPosition(_ lineup: [AnyObject]) {
        expect(lineup[0][0].position).to(equal("gk"))
        expect(lineup[1][0].position).to(equal("df"))
        expect(lineup[1][1].position).to(equal("df"))
        expect(lineup[2][0].position).to(equal("mf"))
        expect(lineup[2][1].position).to(equal("mf"))
        expect(lineup[2][2].position).to(equal("mf"))
        expect(lineup[3][0].position).to(equal("fw"))
        expect(lineup[3][1].position).to(equal("fw"))
    }

    func verifyFieldIndex(_ lineup: [AnyObject]) {
        expect(lineup[0][0].fieldIndex).to(equal(0))
        expect(lineup[1][0].fieldIndex).to(equal(1))
        expect(lineup[1][1].fieldIndex).to(equal(2))
        expect(lineup[2][0].fieldIndex).to(equal(3))
        expect(lineup[2][1].fieldIndex).to(equal(4))
        expect(lineup[2][2].fieldIndex).to(equal(5))
        expect(lineup[3][0].fieldIndex).to(equal(6))
        expect(lineup[3][1].fieldIndex).to(equal(7))
    }
}
