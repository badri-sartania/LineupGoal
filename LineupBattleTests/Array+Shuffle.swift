//
//  Array+Shuffle.swift
//  LineupBattle
//
//  Created by Anders Hansen on 08/10/15.
//  Copyright © 2015 Pumodo. All rights reserved.
//

extension Collection where Index == Int {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Iterator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollection where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }

        // swiftlint:disable variable_name
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
        // swiftlint:enable variable_name
    }
}
