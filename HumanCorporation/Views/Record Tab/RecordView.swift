//
//  AnalysisView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/19.
//
/*
 리스트 형식으로 다이어리를 보여주기...?
 */
import SwiftUI

struct RecordView: View {
    @EnvironmentObject var viewModel: ViewModel
    let dateFormatter = DateFormatter()
    
    var body: some View {
        List {
            ForEach(viewModel.diaryListByDate.keys.sorted().reversed(), id: \.self) { key in
                RecordRow(dateName: dateFormatter.string(from: key), items: viewModel.diaryListByDate[key]!)
            }
            .onAppear() {
                dateFormatter.dateFormat = "YYYY.MM.dd.E"
                viewModel.readDiaryList(completion: { message in
                    print(message)
                })
            }
        }
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView()
            .environmentObject(ViewModel())
    }
}
