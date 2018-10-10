//
//  UltimateXIDataProvider.swift
//  GoalFury
//
//  Created by Morten Hansen on 20/06/2018.
//  Copyright © 2018 GoalFury. All rights reserved.
//

import UIKit

class UltimateXIDataProvider : NSObject{
    var data = UltimateXI()
    
    func fetchData(completion: @escaping (Error?) -> ()){
        HTTP.instance()? .get("/battles/leaderboard/ultimate_xi", params: [:], success: { response in
            if let dict = response as? NSDictionary{
                
                do{
                    var ultimateXI = try UltimateXI(dict)
                    self.data = ultimateXI

                } catch(let error){
                    print(error)
                }
//                ultimateXI.totalPoints = (dict["totalPoints"] as? Int) ?? 0
//                ultimateXI.position = (dict["position"] as? Int) ?? 0
//                if let leaderboardArray = dict["leaderboard"] as?
//                    do{
//                        ultimateXI = UltimateXI.init
//                        leaderboardArray
//                        let data = Data( leaderboardArray
//                        let decoder = JSONDecoder()
//                        decoder.
//                        UltimateXI.init(from: decoder)
//                        let leaderboard = decoder..decode(ultimateXI, from: leaderboardArray.d)
//
//                        if let leaderboard = try MTLJSONAdapter.models(of: Player.self, fromJSONArray: leaderboardArray) as? [Player]{
//                            ultimateXI.leaderBoard = leaderboard
//                        }
//                    }
//                    catch(let error){
//                        print(error)
//                    }
//                }
                completion(nil)
            }
        }, failure: { (error) in
            completion(error)
        })
    }
}

extension UltimateXIDataProvider : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.leaderboard.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerMatchStatsTableViewCell", for: indexPath) as! PlayerMatchStatsTableViewCell
        cell.updateCell(player: data.leaderboard[indexPath.row])
        cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? UIColor.init(white: 0.98, alpha: 1) : UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50)
        let label = UILabel(frame: view.bounds)
        label.font = UIFont.helveticaCondensedBold(size: 15)
        label.textAlignment = .center
        label.textColor = UIColor.primary()
        label.text = "PLAYER EVENTS"
        view.addSubview(label)
        return view
    }
}
