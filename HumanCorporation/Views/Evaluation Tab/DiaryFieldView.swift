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
    @Binding var concentration: Double
    @State var sliderColor: Color = .green
    @State var sliderText: String = "보통"
    
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
                Section("집중도는 생산적인 일에만 반영됩니다.") {
                    VStack {
                        Slider(value: $concentration, in: 1...4, step: 1)
                            .tint(sliderColor)
                        Text("집중도: \(sliderText)")
                    }
                }
            }
            .navigationTitle("Mini Diary")
            .toolbar{
                Button("취소") {
                    showDiary.toggle()
                }
            }
        }
        .onChange(of: concentration) {_ in
            switch concentration {
            case 1:
                sliderText = "슈뢰딩거"
                break
            case 2:
                sliderText = "보통"
                sliderColor = .green
            case 3:
                sliderText = "명석"
                sliderColor = .orange
            case 4:
                sliderText = "도핑"
                sliderColor = .red
            default:
                return
            }
        }
    }
}

struct DiaryFieldView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryFieldView(story: .constant(""), eval: .constant(.neutral), showDiary: .constant(true), concentration: .constant(2))
    }
}
