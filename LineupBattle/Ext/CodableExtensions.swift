//
//  CodableExtensions.swift
//  GoalFury
//
//  Created by Morten Hansen on 20/06/2018.
//  Copyright © 2018 GoalFury. All rights reserved.
//

import Foundation

extension Decodable {
    init(_ any: Any) throws {
        let data = try JSONSerialization.data(withJSONObject: any, options: .prettyPrinted)
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.zzzZ" //2018-06-11T17:35:59.968Z
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        self = try decoder.decode(Self.self, from: data)
    }
}
