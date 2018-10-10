//
//  FontExtensions.swift
//  GoalFury
//
//  Created by Morten Hansen on 20/06/2018.
//  Copyright © 2018 GoalFury. All rights reserved.
//

import UIKit

extension UIFont{
    
    static func helveticaCondensedBold(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-CondensedBold", size: size)!
    }
    
    static func helveticaBold(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Bold", size: size)!
    }
    
    static func helvetica(size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue", size: size)!
    }
}
