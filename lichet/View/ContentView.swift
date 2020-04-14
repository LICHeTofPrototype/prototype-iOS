//
//  ContentView.swift
//  lichet
//
//  Created by 神崎知波 on 2020/04/12.
//  Copyright © 2020 Kanzaki. All rights reserved.
//

import SwiftUI

struct ContentView: View{
    @ObservedObject var viewModel = ContentViewModel(client: PnnClient(session: URLSession.shared))
    var body: some View {
        NavigationView{
            VStack{
                Button("グラフ表示"){
                    self.viewModel.getPnn(userId: 2)
                }
                NavigationLink(destination: GraphView(viewModel: GraphViewModel(pnnDataSet: self.viewModel.pnnDataSet, pnnCountArray: self.viewModel.pnnCountArray)),
                               isActive: self.$viewModel.isActive){
                          EmptyView()
                }.hidden()
            }.onDisappear{
                self.viewModel.cancel()
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
