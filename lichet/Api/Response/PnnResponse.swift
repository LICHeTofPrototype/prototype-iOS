//
//  Pnn.swift
//  lichet
//
//  Created by 神崎知波 on 2020/04/12.
//  Copyright © 2020 Kanzaki. All rights reserved.
//

import Foundation

struct PnnResponse: Codable {
    let id: Int // プライマリ型は初期値必要？
    let measurement: Measurement
    let pnnData: String
    
    private enum CodingKeys: String, CodingKey{
        case id
        case measurement
        case pnnData = "pnn_data"
    }
    struct Measurement: Codable {
        let id: Int
        let startTime: String
        let endTime: String?
        
        private enum CodingKeys: String, CodingKey{
            case id
            case startTime = "start_time"
            case endTime = "end_time"
        }
    }
}
