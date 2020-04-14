//
//  GraphView.swift
//  lichet
//
//  Created by 神崎知波 on 2020/04/13.
//  Copyright © 2020 Kanzaki. All rights reserved.
//

import SwiftUI
import Charts

struct GraphView: View {
    @ObservedObject var viewModel: GraphViewModel
    init(viewModel: GraphViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        GeometryReader{ p in
            VStack{
                Text("Pnn-Data")
                HStack{
                    LineChartSwiftUI(viewModel: self.viewModel)
                        .frame(width: p.size.width*4/5, height: p.size.height*2/3, alignment: .center)
                }
            }
        }
    }
}


struct LineChartSwiftUI: UIViewRepresentable {
    @ObservedObject var viewModel: GraphViewModel
    var yParam: [Double]
    var xParam: [String]
    init(viewModel: GraphViewModel) {
        self.viewModel = viewModel
        self.yParam = viewModel.pnnDataSet
        self.xParam = viewModel.pnnCountArray
    }
    let lineChart = LineChartView()
    
//    let yParam = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
    
    func makeUIView(context: UIViewRepresentableContext<LineChartSwiftUI>) -> LineChartView {
        setLineChart()
        drawLineChart(xValArr: xParam, yValArr: yParam)
        return lineChart
    }
    //グラフ描画部分
    func drawLineChart(xValArr: [String], yValArr: [Double]) {
        
        var yValues : [ChartDataEntry] = [ChartDataEntry]()

        for i in 0 ..< xValArr.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: yValArr[i])
            yValues.append(dataEntry)
        }

        let data = LineChartData()
        let ds = LineChartDataSet(entries: yValues, label: "Pnn")
        
        //グラフのグラデーション有効化
        let gradientColors = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor, #colorLiteral(red: 0.2196078449, green: 1, blue: 0.8549019694, alpha: 1).withAlphaComponent(0.3).cgColor] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [0.7, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object

        ds.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient

        //その他UI設定
        ds.lineWidth = 3.0 //線の太さ
        ds.circleRadius = 3 //プロットの大きさ
        ds.drawCirclesEnabled = true //プロットの表示(今回は表示しない)
        ds.mode = .cubicBezier //曲線にする
        ds.fillAlpha = 0.8 //グラフの透過率(曲線は投下しない)
        ds.drawFilledEnabled = true //グラフ下の部分塗りつぶし
        //ds.fillColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) //グラフ塗りつぶし色
        ds.drawValuesEnabled = false //各プロットのラベル表示(今回は表示しない)
        ds.highlightColor = #colorLiteral(red: 1, green: 0.8392156959, blue: 0.9764705896, alpha: 1) //各点を選択した時に表示されるx,yの線
        ds.colors = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)] //Drawing graph
        ////グラフのUI設定

        data.addDataSet(ds)

        self.lineChart.data = data
    }
    
    func updateUIView(_ uiView: LineChartView, context: Context) {
    }

    func setLineChart() {
        //x軸設定
        lineChart.xAxis.labelPosition = .bottom //x軸ラベル下側に表示
        lineChart.xAxis.labelFont = UIFont.systemFont(ofSize: 11) //x軸のフォントの大きさ
        lineChart.xAxis.labelCount = self.xParam.count > 5 ? 6 : self.xParam.count //x軸に表示するラベルの数
        lineChart.xAxis.labelTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) //x軸ラベルの色
        lineChart.xAxis.axisLineColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) //x軸の色
        lineChart.xAxis.axisLineWidth = CGFloat(1) //x軸の太さ
        lineChart.xAxis.drawGridLinesEnabled = true //x軸のグリッド表示
        lineChart.xAxis.valueFormatter = lineChartFormatter(months: self.xParam)

        //y軸設定
        lineChart.rightAxis.enabled = false //右軸(値)の表示
        lineChart.leftAxis.enabled = true //左軸（値)の表示
        lineChart.leftAxis.axisMaximum = 1 //y左軸最大値
        lineChart.leftAxis.axisMinimum = 0 //y左軸最小値
        lineChart.leftAxis.labelFont = UIFont.systemFont(ofSize: 11) //y左軸のフォントの大きさ
        lineChart.leftAxis.labelTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) //y軸ラベルの色
        lineChart.leftAxis.axisLineColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1) //y左軸の色(今回はy軸消すためにBGと同じ色にしている)
        lineChart.leftAxis.drawAxisLineEnabled = true //y左軸の表示
        lineChart.leftAxis.labelCount = Int(6) //y軸ラベルの表示数
        lineChart.leftAxis.drawGridLinesEnabled = true //y軸のグリッド表示(今回は表示する)
        lineChart.leftAxis.gridColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1) //y軸グリッドの色

        //その他UI設定
        lineChart.noDataFont = UIFont.systemFont(ofSize: 30) //Noデータ時の表示フォント
        lineChart.noDataTextColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) //Noデータ時の文字色
        lineChart.noDataText = "Keep Waiting" //Noデータ時に表示する文字
        lineChart.legend.enabled = true //"■ months"のlegendの表示
        lineChart.legend.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) //"■ months"のテキストカラー
        lineChart.dragDecelerationEnabled = true //指を離してもスクロール続くか
        lineChart.dragDecelerationFrictionCoef = 0.6 //ドラッグ時の減速スピード(0-1)
        lineChart.chartDescription?.text = nil //Description(今回はなし)
        lineChart.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1) //Background Color
        lineChart.animate(xAxisDuration: 1.2, yAxisDuration: 1.5, easingOption: .easeInOutElastic)//グラフのアニメーション(秒数で設定)
    }
}

//x軸のラベルを設定する
public class lineChartFormatter: NSObject, IAxisValueFormatter{
    var months: [String]
    init(months: [String]) {
        self.months = months
    }
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        // 0 -> Jan, 1 -> Feb...
        return months[Int(value)]
    }
}

//struct GraphView_Previews: PreviewProvider {
//    static var previews: some View {
//        GraphView(viewModel: GraphViewModel(pnnDataSet: [0.2, 0.3, 0.4, 0,5]))
//    }
//}
