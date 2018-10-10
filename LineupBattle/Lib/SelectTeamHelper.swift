//
//  TeamPlayerSorter.swift
//  LineupBattle
//
//  Created by Anders Hansen on 18/09/15.
//  Copyright © 2015 Pumodo. All rights reserved.
//

import Foundation

class SelectTeamHelper: NSObject {
    //
    // Data Structure
    //
    // [
    //   teamId: {
    //     team: team
    //     playersByPosition: {
    //       'gk': [player1, player2, ..]
    //       'df': ..
    //     }
    //   },
    //   teamId2: ..
    // ]
    //

    class func selectPlayerDataStructure(_ teams: [Team]) -> [String: [String: AnyObject]] {
        var dic = [String: [String: AnyObject]]()

        teams.forEach() {
            let players = ($0.players as? [Player])!
            let sortedPlayers = (PlayersHelper.sortPlayers(players) as? [Player])!
            dic[$0.objectId] = [
                "team": $0,
                "playersByPosition": SelectTeamHelper.playerToPositionDictionary(sortedPlayers) as AnyObject
            ]
        }

        return dic
    }

    class func playerToPositionDictionary(_ players: [Player]) -> [String: [Player]] {
		var dic = [String: [Player]]()

		for player in players {
			if dic[player.position] == nil {
				dic[player.position] = [Player]()
			}

			dic[player.position]?.append(player)
		}

		return dic
	}
}
