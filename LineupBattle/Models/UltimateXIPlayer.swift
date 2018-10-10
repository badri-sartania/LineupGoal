//
//  UltimateXIPlayer.swift
//  GoalFury
//
//  Created by Morten Hansen on 20/06/2018.
//  Copyright © 2018 GoalFury. All rights reserved.
//


//"points":48,"goals":5,"position":"mf","nationality":"DEN","name":"C. Eriksen","_id":"5a65082552128a720fd8a7eb","new":false,"updatedAt":"2018-06-11T17:35:59.968Z"
import Foundation

enum Position : String, Codable {
    case goalKeeper = "gk"
    case defender = "df"
    case midfielder = "mf"
    case forward = "fw"
}

struct UltimateXIPlayer : Codable {
    var points = 0
    var goals = 0
    var position = Position.goalKeeper
    var nationality = ""
    var name = ""
    var _id = ""
    var new = false
    var updatedAt = Date()
}
