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
 이행률(생산성)    삭제하기
 Complete! Failed -> 시간이 지나야 활성화
 
 먼저 sortedList에 추가 -> 유저가 추가하기 및 알림설정 누를시
 -> viewModel.todoList에도 추가 및 firebase에 등록
 
 삭제시 -> sortedList에서 삭제 -> viewModel.todoList 초기화 및 파이어베이스에서 데이터 삭제
 -> firebase에서 다시 데이터를 읽어들인다.
 */

import SwiftUI

struct PlanView: View {
    @State private var showCalendar = false
    @State private var showCalendarAlert = false
    @State private var date = Date()
    @State private var strDate = "2022.07.22.Fri"
    @State private var sortedList: [Diary] = []
    @State private var showHide: [Bool] = []
    @FocusState private var storyFocused: Bool
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            List {
                Section("날짜를 선택하세요.") {
                    Button {
                        showCalendarAlert.toggle()
                    } label: {
                        Label(strDate, systemImage: "calendar")
                            .tint(.primary)
                    }.buttonStyle(BorderlessButtonStyle())
                }
                ForEach(sortedList.indices, id: \.self) { idx in
                    VStack(spacing: 20){
                        Button {
                            showHide[idx].toggle()
                        } label: {
                            Label(sortedList[idx].story, systemImage: showHide[idx] ? "chevron.down.circle.fill":"chevron.forward.circle.fill")
                                .foregroundColor(.orange)
                        }.buttonStyle(BorderlessButtonStyle())
                        
                        if showHide[idx] {
                            HStack{
                                DatePicker("시작시간", selection: $sortedList[idx].startTime, displayedComponents: [.hourAndMinute])
                                DatePicker("종료시간", selection: $sortedList[idx].endTime, in: sortedList[idx].startTime..., displayedComponents: [.hourAndMinute])
                            }
                            VStack{
                                ZStack{
                                    HStack{
                                        TextEditor(text: $sortedList[idx].story)
                                            .focused($storyFocused)
                                            .foregroundColor(.secondary)
                                        Button{
                                            viewModel.deleteToDo(endTime: sortedList[idx].endTime)
                                            sortedList.remove(at: idx)
                                            viewModel.readToDoList(completion: { message in
                                                print(message)
                                            })
                                        } label: {
                                            Label("", systemImage: "trash.fill")
                                                .foregroundColor(.purple)
                                        }.buttonStyle(BorderlessButtonStyle())
                                    }
                                    Rectangle()
                                        .fill(.clear)
                                        .border(.orange, width: 1)
                                }
                                HStack(){
                                    Button{
                                        sortedList[idx].eval = .productive
                                    } label: {
                                        Label("생산적", systemImage: sortedList[idx].eval == .productive ?  "checkmark.circle.fill":"plus.circle")
                                            .foregroundColor(.red)
                                    }.buttonStyle(BorderlessButtonStyle())
                                    Button{
                                        sortedList[idx].eval = .unproductive
                                    } label: {
                                        Label("비생산/여가", systemImage: sortedList[idx].eval == .unproductive ?  "checkmark.circle.fill":"minus.circle")
                                            .foregroundColor(.blue)
                                    }.buttonStyle(BorderlessButtonStyle())
                                    Button{
                                        sortedList[idx].eval = .neutral
                                    } label: {
                                        Label("생리현상", systemImage: sortedList[idx].eval == .neutral ?  "checkmark.circle.fill":"moon.zzz")
                                            .foregroundColor(.green)
                                    }.buttonStyle(BorderlessButtonStyle())
                                }
                            }
                            VStack {
                                Slider(value: $sortedList[idx].concentration, in: 1...4, step: 1)
                                    .tint(.green)
                                Text("집중도(생산성)")
                            }
                        }
                    }
                }
                Section {
                    Button {
                        if sortedList.isEmpty {
                            let diary = Diary(story: "할 일을 적어주세요.", startTime: Calendar.current.startOfDay(for: date), endTime: Calendar.current.startOfDay(for: date))
                            sortedList.append(diary)
                        } else {
                            let diary = Diary(story: "할 일을 적어주세요.", startTime: sortedList.last!.endTime, endTime: sortedList.last!.endTime)
                            sortedList.append(diary)
                        }
                        showHide.append(true)
                    } label: {
                        Label("할 일 추가하기", systemImage: "plus.circle.fill")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            .listStyle(.inset)
        }
        .onTapGesture {
            storyFocused = false
        }
        .navigationTitle("To Do List Style")
        .alert("주의! 날짜를 재선택하는 경우 임시 저장된 데이터가 초기화됩니다.", isPresented: $showCalendarAlert) {
            Button("계속") {
                showCalendar.toggle()
            }
            Button("취소", role: .cancel) {
            }
        }
        .sheet(isPresented: $showCalendar, onDismiss: updateSelectedDate){
            DatePicker("날짜를 고르세요.", selection: $date, in: viewModel.recentDay..., displayedComponents: [.date])
                .datePickerStyle(.graphical)
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
                //뷰 타이틀 변경하기
                date = sortedList.last!.endTime
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
        sortedList.removeAll()
        if viewModel.todoList.isEmpty == false {
            viewModel.removeTemp()
            viewModel.todoList.removeAll()
        }
        //1. 캘린더 날짜 선택기간 제한
        if viewModel.priceList.isEmpty == false {
            viewModel.findRecentDay(completion: { message in
                print(message)
            })
        }
        //4. 시간 세팅하기
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
