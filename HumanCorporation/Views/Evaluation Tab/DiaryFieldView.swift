//
//  DiaryFieldView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/27.
//

import SwiftUI

struct DiaryFieldView: View {
    @Binding var story: String
    @Binding var eval: Diary.Evaluation
    @Binding var showDiary: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section("이 시간에 무엇을 하셨나요? 생산적이었나요?") {
                    HStack{
                        TextEditor(text: $story)
                        VStack(alignment: .leading, spacing: 20){
                            Button{
                                eval = .productive
                                showDiary.toggle()
                            } label: {
                                Label("생산적", systemImage: "plus.circle")
                            }.buttonStyle(BorderlessButtonStyle())
                            Button{
                                eval =  .unproductive
                                showDiary.toggle()
                            } label: {
                                Label("비생산/여가", systemImage: "minus.circle")
                            }.buttonStyle(BorderlessButtonStyle())
                            Button{
                                eval = .neutral
                                showDiary.toggle()
                            } label: {
                                Label("생리현상", systemImage: "moon.zzz")
                            }.buttonStyle(BorderlessButtonStyle())
                        }
                    }
                }
            }
            .navigationTitle("실적표")
            .toolbar{
                Button("취소") {
                    showDiary.toggle()
                }
            }
        }
    }
}

struct DiaryFieldView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryFieldView(story: .constant(""), eval: .constant(.neutral), showDiary: .constant(true))
    }
}
