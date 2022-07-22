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
        chart.maxVisibleCount = 200
        chart.data = addData()
        return chart
    }
    
    func updateUIView(_ uiView: CandleStickChartView, context: Context) {
        uiView.data = addData()
    }
    
    func addData() -> CandleChartData {
        let data = CandleChartData()
        let dataset = CandleChartDataSet(entries: entries)
        //customize candle chart
        dataset.decreasingColor = .blue
        dataset.decreasingFilled = true
        dataset.increasingColor = .red
        dataset.increasingFilled = true
        dataset.neutralColor = .green
        dataset.shadowColor = .darkGray
        dataset.shadowWidth = 1.5
        dataset.axisDependency = .left
        //
        data.addDataSet(dataset)
        return data
    }
}
