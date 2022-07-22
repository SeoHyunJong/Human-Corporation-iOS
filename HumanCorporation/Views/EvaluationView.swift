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
import SwiftUI
//24hr == 86400
struct EvaluationView: View {
    let dateFormatter = DateFormatter()
    @State private var showCalendar = false
    @State private var date = Date()
    @State private var strDate = "2022.07.22.Fri"
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var pickStart = Date()
    @State private var pickEnd = Date()
    
    var body: some View {
        NavigationView{
            Form{
                Section("시간 선택") {
                    DatePicker("시작 시간", selection: $startTime, in: pickStart...pickEnd)
                    DatePicker("종료 시간", selection: $endTime, in: pickEnd...Date())
                    Label(String(format: "%.0f", endTime.timeIntervalSince(startTime) / 60)+" min", systemImage: "clock")
                }
                Section("실적 추가") {
                    
                }
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
    }
    func updateSelectedDate(){
        strDate = dateFormatter.string(from: date)
        startTime = Calendar.current.startOfDay(for: date)
        endTime = Calendar.current.startOfDay(for: date)
        pickStart = Calendar.current.startOfDay(for: date)
        pickEnd = Calendar.current.startOfDay(for: date)
    }
}

struct EvaluationView_Previews: PreviewProvider {
    static var previews: some View {
        EvaluationView()
    }
}
