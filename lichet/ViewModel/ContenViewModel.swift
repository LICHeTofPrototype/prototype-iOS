//
//  ContenViewModel.swift
//  lichet
//
//  Created by 神崎知波 on 2020/04/13.
//  Copyright © 2020 Kanzaki. All rights reserved.
//

import Foundation
import Combine

final class ContentViewModel: ObservableObject{
        
    private let client: PnnClient
    var cancelable: AnyCancellable?
    @Published var isActive: Bool = false
    @Published var pnnDataSet: [Double] = []
    @Published var pnnCountArray: [String] = []
    
    init(client: PnnClient){
        self.client = client
    }
    func getPnn(userId: Int) -> Void {
        self.cancelable = client.getPnn(userId: userId)
            .sink(receiveCompletion: { completion in
                switch completion{
                case .finished:
                    print("success")
                    self.isActive = true
                    break
                case .failure(let error):
                    print(error)
                    self.isActive = false
                    break
                }
            }) { value in
                print(value)
                let pnnArray = value.pnnData.split(separator: ",").map{String($0.trimmingCharacters(in: .whitespaces))}
                self.pnnDataSet = pnnArray.map({Double($0) ?? 0})
                self.pnnCountArray = pnnArray.enumerated().map{  "\($0.offset + 1)回目" }
        }
    }
    func cancel(){
        cancelable?.cancel()
        cancelable = nil
    }
}
