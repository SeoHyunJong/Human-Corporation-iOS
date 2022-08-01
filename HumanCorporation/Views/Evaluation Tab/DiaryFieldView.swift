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
    @State var sectionText: String = "무난한 집중력 상태였습니다."
    @FocusState private var storyFocused: Bool
    
    var body: some View {
        NavigationView {
            List {
                Section("이 시간에 무엇을 하셨나요? 생산적이었나요?") {
                    HStack{
                        ZStack {
                            TextEditor(text: $story)
                                .focused($storyFocused)
                            Rectangle()
                                .fill(.clear)
                                .border(.blue, width: 1)
                        }
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
                Section(sectionText) {
                    VStack {
                        Slider(value: $concentration, in: 1...4, step: 1)
                            .tint(sliderColor)
                        Text("집중도(생산성): \(sliderText)")
                    }
                }
                MessageBox(message: "집중도는 그 시간동안 너의 퍼포먼스를 의미한다! 생산적인 일에만 집중도가 반영된다!", leftSpeaker: true)
                MessageBox(message: "생리현상에는 어떤게 포함돼? 내가 샤워하거나 볼 일 보는 것도 비생산적이야?", leftSpeaker: false)
                MessageBox(message: "지구인들의 수면, 위생, 식사 등 생존에 있어서 필요한 모든 행동들은 생리현상이다!", leftSpeaker: true)
            }
            .listStyle(.plain)
            .navigationTitle("Mini Diary")
            .toolbar{
                Button("취소") {
                    showDiary.toggle()
                }
            }
        }
        .onTapGesture {
            storyFocused = false
        }
        .onChange(of: concentration) {_ in
            switch concentration {
            case 1:
                sectionText = "당신은 집중한 상태이기도 하고 아니기도 했습니다(...)"
                sliderText = "슈뢰딩거"
                break
            case 2:
                sectionText = "무난한 집중력 상태였습니다."
                sliderText = "보통"
                sliderColor = .green
            case 3:
                sectionText = "당신은 이때 명석했습니다."
                sliderText = "명석"
                sliderColor = .orange
            case 4:
                sectionText = "당신은 사기적인 집중력을 가지고 있었습니다!"
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
