//
//  EvaluationView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/19.
//
/*
 오늘 날짜      날짜 선택   하루 초기화
 시작 시간
 종료 시간
 소요 시간
 간단한 일기장    +, -, N
 바 그래프 표시
 남은 시간 표시
 하루 일과 완성하기
 */
//24hr == 86400
import SwiftUI
import AlertToast

struct EvaluationView: View {
    let dateFormatter = DateFormatter()
    @State private var showCalendar = false
    @State private var date = Date()
    @State private var strDate = "2022.07.22.Fri"
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var pickStart = Date()
    @State private var story = "일과를 작성해주세요."
    @State private var showToast = false
    @State private var showError = false
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView{
            VStack(alignment: .center) {
                Form{
                    Section("그날의 자정부터 순서대로 기록해주세요.") {
                        DatePicker("시작 시간", selection: $startTime, in: pickStart...pickStart)
                        DatePicker("종료 시간", selection: $endTime, in: pickStart...Date())
                        Label(String(format: "%.0f", endTime.timeIntervalSince(startTime) / 60)+" min", systemImage: "clock")
                    }
                    Section("이때 무슨 일을 하셨나요? 생산적인 일이었나요?") {
                        HStack{
                            TextEditor(text: $story)
                            VStack(alignment: .leading, spacing: 20){
                                Button{
                                    if endTime.timeIntervalSince(startTime) > 0 {
                                        let diary = Diary(story: story, startTime: startTime, endTime: endTime, eval: .productive)
                                        viewModel.diaryAdd(diary: diary, strDate: strDate)
                                        pickStart = endTime
                                        showToast = true
                                        story = "일과를 작성해주세요."
                                    } else {
                                        showError = true
                                    }
                                } label: {
                                    Label("생산적", systemImage: "plus.circle")
                                }
                                Button{
                                    if endTime.timeIntervalSince(startTime) > 0 {
                                        pickStart = endTime
                                        showToast = true
                                        story = "일과를 작성해주세요."
                                    } else {
                                        showError = true
                                    }
                                } label: {
                                    Label("비생산적", systemImage: "minus.circle")
                                }
                                Button{
                                    if endTime.timeIntervalSince(startTime) > 0 {
                                        pickStart = endTime
                                        showToast = true
                                        story = "일과를 작성해주세요."
                                    } else {
                                        showError = true
                                    }
                                } label: {
                                    Label("생리현상", systemImage: "moon.zzz")
                                }
                            }
                        }
                    }
                    
                }
                HStack() {
                    Button{
                        
                    } label: {
                        Text("실적 최종 제출")
                            .foregroundColor(Color.white)
                            .padding(.vertical,10)
                            .padding(.horizontal,15)
                            .background(Color.blue)
                            .cornerRadius(45)
                    }
                    Button{
                        
                    } label: {
                        Text("실적 초기화")
                            .foregroundColor(Color.white)
                            .padding(.vertical,10)
                            .padding(.horizontal,15)
                            .background(Color.red)
                            .cornerRadius(45)
                    }
                }
                Spacer()
            }
            .navigationTitle(strDate)
            .toolbar{
                Label("select date", systemImage: "calendar")
                    .onTapGesture {
                        showCalendar.toggle()
                    }
            }
        }
        .onAppear(){
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "YYYY.MM.dd.E"
            updateSelectedDate()
        }
        .sheet(isPresented: $showCalendar, onDismiss: updateSelectedDate){
            DatePicker("날짜를 고르세요.", selection: $date, in: ...Date(), displayedComponents: [.date])
                .datePickerStyle(.graphical)
        }
        .toast(isPresenting: $showToast) {
            AlertToast(displayMode: .banner(.slide), type: .regular, title:"실적 추가 성공!")
        }
        .toast(isPresenting: $showError) {
            AlertToast(displayMode: .alert, type: .error(.red), title: "유효하지 않는 시간!")
        }
    }
    func updateSelectedDate(){
        strDate = dateFormatter.string(from: date)
        startTime = Calendar.current.startOfDay(for: date)
        endTime = Calendar.current.startOfDay(for: date)
        pickStart = Calendar.current.startOfDay(for: date)
    }
}

struct EvaluationView_Previews: PreviewProvider {
    static var previews: some View {
        EvaluationView()
            .environmentObject(ViewModel())
    }
}
