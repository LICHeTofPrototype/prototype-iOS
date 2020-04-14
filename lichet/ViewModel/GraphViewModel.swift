//
//  GraphViewModel.swift
//  lichet
//
//  Created by 神崎知波 on 2020/04/13.
//  Copyright © 2020 Kanzaki. All rights reserved.
//

import Foundation
import Combine

class GraphViewModel: ObservableObject {
    @Published var pnnDataSet: [Double]
    @Published var pnnCountArray: [String]

    init(pnnDataSet: [Double], pnnCountArray: [String]) {
        self.pnnDataSet = pnnDataSet
        self.pnnCountArray = pnnCountArray
    }
    
}
