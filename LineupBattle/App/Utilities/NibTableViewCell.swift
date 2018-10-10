//
//  NibTableViewCell.swift
//  GoalFury
//
//  Created by Morten Hansen on 19/06/2018.
//  Copyright © 2018 GoalFury. All rights reserved.
//

import UIKit

// MARK: - protocols

protocol UITableViewCellNibLoadable : UIViewNibLoadable {
    static var reuseIdentifier: String { get }
}

// MARK: - protocol extensions

extension UITableViewCellNibLoadable {
    static var reuseIdentifier: String { return NSStringFromClass(self).components(separatedBy: ".").last!  }
}

extension UITableView {
    func registerCellClass<T>(_ cellClass: T.Type) where T: UITableViewCell, T: UITableViewCellNibLoadable {
        register(cellClass.nib, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
    func registerHeaderFooterClass<T: UITableViewCellNibLoadable>(_ cellClass: T.Type) {
        register(cellClass.nib, forHeaderFooterViewReuseIdentifier: cellClass.reuseIdentifier)
    }
}
