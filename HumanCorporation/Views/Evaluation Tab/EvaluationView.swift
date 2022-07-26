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
//1 min == 0.04%
import SwiftUI
import AlertToast
import Charts

struct EvaluationView: View {
    @State private var showCalendar = false
    @State private var date = Date()
    @State private var strDate = "2022.07.22.Fri"
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var pickStart = Date()
    @State private var story = "일과를 작성해주세요."
    
    @State private var showToast = false
    @State private var showError = false
    @State private var showSuccess = false
    
    @EnvironmentObject var viewModel: ViewModel
    @State private var diaryList:[Diary] = []
    @State private var previousClose: Double = 1000
    @State private var currentPrice: Double = 1000
    @State private var priceList:[Double] = []
    
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
                                    addDiary(eval: .productive)
                                } label: {
                                    Label("생산적", systemImage: "plus.circle")
                                }.buttonStyle(BorderlessButtonStyle())
                                Button{
                                    addDiary(eval: .unproductive)
                                } label: {
                                    Label("비생산/여가", systemImage: "minus.circle")
                                }.buttonStyle(BorderlessButtonStyle())
                                Button{
                                    addDiary(eval: .neutral)
                                } label: {
                                    Label("생리현상", systemImage: "moon.zzz")
                                }.buttonStyle(BorderlessButtonStyle())
                            }
                        }
                    }
                    Section("현재 가격") {
                        Label(String(format: "%.0f", currentPrice), systemImage: "dollarsign.circle.fill")
                    }
                }
                HStack() {
                    Button{
                        if priceList.count > 0 {
                            viewModel.diaryAdd(diaryList: diaryList)
                            let price = CandleChartDataEntry(x: 0, shadowH: priceList.max()!, shadowL: priceList.min()!, open: priceList.first!, close: priceList.last!)
                            viewModel.priceAdd(price: price)
                            viewModel.findRecentDay()
                            date = date.addingTimeInterval(86400)
                            updateSelectedDate()
                            
                            showSuccess.toggle()
                        } else {
                            showError.toggle()
                        }
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
                        Text("다시 작성하기")
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
            updateSelectedDate()
            if viewModel.priceList.isEmpty == false {
                viewModel.findRecentDay()
                previousClose = viewModel.priceList.last!.close
                currentPrice = previousClose
            }
        }
        .sheet(isPresented: $showCalendar, onDismiss: updateSelectedDate){
            DatePicker("날짜를 고르세요.", selection: $date, in: viewModel.recentDay...Date(), displayedComponents: [.date])
                .datePickerStyle(.graphical)
        }
        .toast(isPresenting: $showToast) {
            AlertToast(displayMode: .banner(.slide), type: .regular, title:"실적 추가 성공!")
        }
        .toast(isPresenting: $showError) {
            AlertToast(displayMode: .alert, type: .error(.red), title: "잘못된 입력")
        }
        .toast(isPresenting: $showSuccess) {
            AlertToast(displayMode: .alert, type: .complete(.green), title: "실적 제출 성공!")
        }
    }
    func updateSelectedDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd.E"
        strDate = dateFormatter.string(from: date)
        startTime = Calendar.current.startOfDay(for: date)
        endTime = Calendar.current.startOfDay(for: date)
        pickStart = Calendar.current.startOfDay(for: date)
    }
    func addDiary(eval: Diary.Evaluation) {
        if endTime.timeIntervalSince(startTime) > 0 {
            let diary = Diary(story: story, startTime: startTime, endTime: endTime, eval: eval)
            diaryList.append(diary)
            
            let time = endTime.timeIntervalSince(startTime) / 60
            let variance = previousClose * (time * 0.04) * 0.01
            
            switch eval {
            case .productive:
                currentPrice += variance
                self.priceList.append(currentPrice)
            case .unproductive:
                currentPrice -= variance
                self.priceList.append(currentPrice)
            case .neutral:
                self.priceList.append(currentPrice)
            }
            
            pickStart = endTime
            startTime = endTime
            showToast.toggle()
            story = "일과를 작성해주세요."
        } else {
            showError.toggle()
        }
    }
}

struct EvaluationView_Previews: PreviewProvider {
    static var previews: some View {
        EvaluationView()
            .environmentObject(ViewModel())
    }
}
