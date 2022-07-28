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
        chart.noDataText = "데이터가 없습니다."
        chart.noDataFont = .systemFont(ofSize: 20)
        chart.noDataTextColor = .lightGray
        chart.xAxis.setLabelCount(4, force: false)
        chart.xAxis.labelPosition = .bottom
        chart.dragDecelerationEnabled = false
        chart.autoScaleMinMaxEnabled = true
        chart.doubleTapToZoomEnabled = false
        chart.highlightPerTapEnabled = false
        chart.rightAxis.enabled = false
        chart.leftAxis.enabled = true
        chart.scaleYEnabled = false
        chart.dragYEnabled = false
        chart.data = addData()
        chart.animate(xAxisDuration: 1)
        return chart
    }
    
    func updateUIView(_ uiView: CandleStickChartView, context: Context) {
        uiView.data = addData()
    }
    
    func addData() -> CandleChartData {
        let data = CandleChartData()
        //Charts 라이브러리 버그 때문에 dataset 추가전 정렬이 필요하다.
        let sortEntry = entries.sorted(by: {$0.x < $1.x})
        let dataset = CandleChartDataSet(entries: sortEntry)
        //customize candle chart
        dataset.decreasingColor = .blue
        dataset.decreasingFilled = true
        dataset.increasingColor = .red
        dataset.increasingFilled = true
        dataset.neutralColor = .green
        dataset.shadowColorSameAsCandle = true
        dataset.shadowWidth = 1.5
        dataset.drawValuesEnabled = false
        //
        data.addDataSet(dataset)
        return data
    }
}
