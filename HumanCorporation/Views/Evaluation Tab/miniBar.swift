import Charts
import SwiftUI

struct miniBar: UIViewRepresentable {
    typealias UIViewType = CandleStickChartView
    //data array
    var priceList: [Double]
    
    func makeUIView(context: Context) -> CandleStickChartView {
        let chart = CandleStickChartView()
        chart.data = addData()
        
        chart.xAxis.setLabelCount(1, force: true)
        chart.xAxis.labelPosition = .bottom
        chart.rightAxis.enabled = false
        chart.leftAxis.enabled = true
        return chart
    }
    
    func updateUIView(_ uiView: CandleStickChartView, context: Context) {
        uiView.data = addData()
    }
    
    func addData() -> CandleChartData {
        let data = CandleChartData()
        let entry = CandleChartDataEntry(x: 0, shadowH: priceList.max() ?? 1000, shadowL: priceList.min() ?? 1000, open: priceList.first ?? 1000, close: priceList.last ?? 1000)
        let dataset = CandleChartDataSet(entries: [entry])
        //customize candle chart
        dataset.decreasingColor = .blue
        dataset.decreasingFilled = true
        dataset.increasingColor = .red
        dataset.increasingFilled = true
        dataset.neutralColor = .green
        dataset.shadowColor = .systemYellow
        dataset.shadowWidth = 1.5
        dataset.axisDependency = .left
        //
        data.addDataSet(dataset)
        return data
    }
}

