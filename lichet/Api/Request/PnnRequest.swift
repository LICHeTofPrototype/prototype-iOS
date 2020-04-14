//
//  Pnn.swift
//  lichet
//
//  Created by 神崎知波 on 2020/04/13.
//  Copyright © 2020 Kanzaki. All rights reserved.
//

import Foundation

struct PnnRequest: Codable {
    var userId = Int()
    private enum CodingKeys: String, CodingKey{
        case userId = "user_id"
    }
}
