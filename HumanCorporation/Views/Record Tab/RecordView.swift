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
            VStack {
                List(viewModel.diaryListByDate.keys.sorted().reversed(), id: \.self) { key in
                    NavigationLink {
                        RecordRow(dateName: dateFormatter.string(from: key), items: viewModel.diaryListByDate[key]!)
                    } label: {
                        Text(dateFormatter.string(from: key))
                    }
                }
                .navigationTitle("History")
                .listStyle(.plain)
                MessageBox(message: "여기서 너가 썼던 일기들을 감상할 수 있다. 최대 300개까지 저장된다!", leftSpeaker: true)
            }
            .toolbar {
                Button{
                    viewModel.diaryListFromFirebase.removeAll()
                    viewModel.readDiaryList(completion: { message in
                        print(message)
                    })
                } label: {
                    Label("새로고침", systemImage: "goforward")
                }
            }
        }
        .navigationViewStyle(.stack)
        .onAppear() {
            dateFormatter.dateFormat = "YYYY.MM.dd.E"
        }
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView()
            .environmentObject(ViewModel())
    }
}
