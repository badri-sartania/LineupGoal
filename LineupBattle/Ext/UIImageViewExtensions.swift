//
//  UIImageViewExtensions.swift
//  GoalFury
//
//  Created by Morten Hansen on 22/06/2018.
//  Copyright © 2018 GoalFury. All rights reserved.
//

import UIKit
import AFNetworking


extension UIImageView {

    func setPlayerImage(id: String, placeholder : UIImage? = nil) {
        //https://goalfury-public.s3-eu-west-1.amazonaws.com/players/${player._id}.jpg
        let url = URL.init(string: "https://goalfury-public.s3-eu-west-1.amazonaws.com/players/\(id).jpg")
        setImage(url: url)
    }
    
    func setImage(url : URL?, placeholder : UIImage? = nil){
        if let url = url{
            setImageWith(url, placeholderImage: placeholder)
        } else if let image = placeholder{
            self.image = image
        }
    }
}
