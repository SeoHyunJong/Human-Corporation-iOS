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
    @State private var dateFormatter = DateFormatter()
    
    var body: some View {
        NavigationView {
            List(viewModel.diaryListByDate.keys.sorted().reversed(), id: \.self) { key in
                NavigationLink {
                    RecordRow(dateName: dateFormatter.string(from: key), items: viewModel.diaryListByDate[key]!)
                } label: {
                     Text(dateFormatter.string(from: key))
                }
            }
            .navigationTitle("Announcement")
            .listStyle(.plain)
        }
        .onAppear() {
            dateFormatter.dateFormat = "YYYY.MM.dd.E"
            viewModel.readDiaryList(completion: { message in
                print(message)
            })
        }
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView()
            .environmentObject(ViewModel())
    }
}
