//
//  ChartView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/19.
//

import SwiftUI
import Charts

struct ChartView: View {
    var body: some View {
        Bar(entries: [
            CandleChartDataEntry(x: 1, shadowH: 10, shadowL: 4, open: 6, close: 8),
            CandleChartDataEntry(x: 2, shadowH: 9, shadowL: 4, open: 8, close: 4),
            CandleChartDataEntry(x: 3, shadowH: 7, shadowL: 3, open: 4, close: 7),
            CandleChartDataEntry(x: 4, shadowH: 15, shadowL: 5, open: 7, close: 12)])
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}
