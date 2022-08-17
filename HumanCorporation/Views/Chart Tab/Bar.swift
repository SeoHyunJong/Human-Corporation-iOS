//
//  Bar.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/21.
//
import Charts
import SwiftUI

struct Bar: UIViewRepresentable {
    typealias UIViewType = CandleStickChartView
    //data array
    var entries: [CandleChartDataEntry]
    
    func makeUIView(context: Context) -> CandleStickChartView {
        let chart = CandleStickChartView()
        //chart attribute
        chart.noDataText = "실적 추가 탭에서 일기를 작성하세요."
        chart.noDataFont = .systemFont(ofSize: 20)
        chart.noDataTextColor = .lightGray
        
        chart.xAxis.setLabelCount(4, force: true)
        chart.xAxis.labelPosition = .bottom
        chart.dragDecelerationEnabled = false
        chart.autoScaleMinMaxEnabled = true
        chart.doubleTapToZoomEnabled = false
        chart.highlightPerTapEnabled = false
        chart.rightAxis.enabled = false
        chart.leftAxis.enabled = true
        chart.scaleYEnabled = false
        chart.dragYEnabled = false
        
        if !entries.isEmpty {
            chart.data = addData()
        }
        chart.animate(yAxisDuration: 1.5)
        return chart
    }
    
    func updateUIView(_ uiView: CandleStickChartView, context: Context) {
        if !entries.isEmpty {
            uiView.data = addData()
        }
    }
    
    func addData() -> CandleChartData {
        let data = CandleChartData()
        let dataset = CandleChartDataSet(entries: entries, label: "인간가치")
        //customize candle chart
        dataset.decreasingColor = .blue
        dataset.decreasingFilled = true
        dataset.increasingColor = .red
        dataset.increasingFilled = true
        dataset.neutralColor = .green
        dataset.shadowColorSameAsCandle = true
        dataset.shadowWidth = 1.5
        data.addDataSet(dataset)
        return data
    }
}

struct Bar_Previews: PreviewProvider {
    static var previews: some View {
        Bar(entries:
        [CandleChartDataEntry(x: 0, shadowH: 1100, shadowL: 970, open: 1000, close: 1050),
        CandleChartDataEntry(x: 1, shadowH: 1150, shadowL: 1000, open: 1050, close: 1110),
        CandleChartDataEntry(x: 2, shadowH: 1140, shadowL: 1000, open: 1110, close: 1050)])
    }
}
