//
// Created by Anders Hansen on 30/09/15.
// Copyright (c) 2015 Pumodo. All rights reserved.
//

import UIKit

@objc class SDKTraits: NSObject {
    class func hasForceTouchForView(_ view: UIView) -> Bool {
        guard #available(iOS 9.0, *) else {
            return false
        }

        let forceTouchAvailable = view.traitCollection.forceTouchCapability
        return forceTouchAvailable == UIForceTouchCapability.available
    }

    class func SDKVersion () -> Float {
        return Float(UIDevice.current.systemVersion)!
    }
}
