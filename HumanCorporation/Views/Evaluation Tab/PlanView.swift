//
//  PlanView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/09/05.
//
/*
 날짜 선택
 +일기추가
 
 시작예정   종료예정
 내용     생산적, 비생산적, 생리현상
 계획 이행률(생산성) -> 시간이 지나야 활성화    삭제하기
 Complete! Failed -> 시간이 지나야 활성화
 */

import SwiftUI

struct PlanView: View {
    @State private var showCalendar = false
    @State private var showCalendarAlert = false
    @State private var date = Date()
    @State private var strDate = "2022.07.22.Fri"
    @State private var sortedList: [Diary] = []
    @State private var startTime = Date()
    @State private var endTime = Date()
    
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            List {
                Section("Step 1. 날짜를 선택하세요!") {
                    Button {
                        showCalendarAlert.toggle()
                    } label: {
                        Label(strDate, systemImage: "calendar")
                    }
                }
            }
            .alert("주의! 날짜를 재선택하는 경우 임시 저장된 데이터가 초기화됩니다.", isPresented: $showCalendarAlert) {
                Button("계속") {
                    showCalendar.toggle()
                }
                Button("취소", role: .cancel) {
                }
            }
            .sheet(isPresented: $showCalendar, onDismiss: updateSelectedDate){
                DatePicker("날짜를 고르세요.", selection: $date, in: viewModel.recentDay...Date(), displayedComponents: [.date])
                    .datePickerStyle(.graphical)
            }
        }
        .onAppear(){
            //자동으로 임시저장된 데이터를 불러온다.
            if viewModel.todoList.count > 0 {
                //캘린더 날짜 선택기간 제한
                if viewModel.priceList.isEmpty == false {
                    viewModel.findRecentDay(completion: { message in
                        print(message)
                    })
                }
                //정렬한다.
                sortToDoList()
                //시간 세팅하기
                endTime = sortedList.last!.endTime
                startTime = endTime
                //뷰 타이틀 변경하기
                date = endTime
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY.MM.dd.E"
                strDate = dateFormatter.string(from: date)
            } else {
                updateSelectedDate()
            }
        }
    }
    func updateSelectedDate(){
        //0. 임시 저장된 데이터 삭제하기 (날짜를 새로 선택했으므로)
        if viewModel.todoList.isEmpty == false {
            viewModel.removeTemp()
            viewModel.todoList.removeAll()
            sortedList.removeAll()
        }
        //1. 캘린더 날짜 선택기간 제한
        if viewModel.priceList.isEmpty == false {
            viewModel.findRecentDay(completion: { message in
                print(message)
            })
        }
        //4. 시간 세팅하기
        endTime = Calendar.current.startOfDay(for: date)
        startTime = endTime
        //5. 뷰 타이틀 변경하기
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd.E"
        strDate = dateFormatter.string(from: date)
    }
    func sortToDoList() {
        sortedList = viewModel.todoList.sorted{ $0.startTime < $1.startTime }
    }
}

struct PlanView_Previews: PreviewProvider {
    static var previews: some View {
        PlanView()
            .environmentObject(ViewModel())
    }
}
