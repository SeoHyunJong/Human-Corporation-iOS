//
//  EvaluationView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/19.
//
/*
 일기 추가할때 시간 검사
 range.overlap을 이용하면 된다!!
 시간 선택에 자유를 주었으니 대신,
 시스템에서 다이어리 리스트 정렬과 가격 리스트를 새로 생성해야.
 */
//24hr == 86400
//1 min == 0.01% ~ 0.04%
import SwiftUI
import AlertToast
import Charts

struct EvaluationView: View {
    @State private var showCalendar = false
    
    //최중요 프로퍼티들
    @State private var date = Date()
    @State private var strDate = "2022.07.22.Fri"
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var previousClose: Double = 1000
    @State private var currentPrice: Double = 1000
    //tempDiaryList는 시간 순서와 상관없이 유저가 추가한 순서대로 배열. -> undoAction에 필요
    //sortedDiary는 시간 순서대로 정렬된 diary.
    @State private var sortedDiary: [Diary] = []
    @State private var sortedPrice: [Double] = []
    @State private var amountOfProductive: Double = 0
    @State private var amountOfUnproductive: Double = 0
    @State private var amountOfNeutral: Double = 0
    //------------
    
    @State private var story = ""
    @State private var eval = Diary.Evaluation.cancel
    @State private var concentration: Double = 2
    
    @State private var showToast = false
    @State private var showSuccess = false
    @State private var showError = false
    @State private var showDiary = false
    @State private var showAlert = false
    @State private var showCalendarAlert = false
    
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack {
                Text(strDate)
                    .font(.system(size: 25, weight: .bold, design: .default))
                    .onTapGesture {
                        showCalendarAlert.toggle()
                    }
                Spacer()
                Button {
                    showCalendarAlert.toggle()
                } label: {
                    Label("", systemImage: "calendar")
                }
            }.padding()
            List{
                Section("시간별로 일기를 작성하여 실적을 완성하세요!") {
                    DatePicker("일기 시작 시간", selection: $startTime, displayedComponents: [.hourAndMinute])
                    DatePicker("일기 종료 시간", selection: $endTime, in: startTime..., displayedComponents: [.hourAndMinute])
                    HStack {
                        Label(String(format: "%.0f", endTime.timeIntervalSince(startTime) / 60)+" min", systemImage: "clock")
                        Spacer()
                        Button {
                            eval = .cancel
                            concentration = 2
                            showDiary.toggle()
                        } label: {
                            Label("미니 일기 작성", systemImage: "plus.circle.fill")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .disabled(endTime.timeIntervalSince(startTime) > 0 ? false:true)
                    }
                    HStack(spacing: 30) {
                        CircleTimeView()
                        VStack(alignment: .leading) {
                            HStack {
                                Label("", systemImage: "plus.circle")
                                Text(String(format: "%.1f", amountOfProductive)+" h")
                            }.foregroundColor(.red)
                            HStack {
                                Label("", systemImage: "minus.circle")
                                Text(String(format: "%.1f", amountOfUnproductive)+" h")
                            }.foregroundColor(.blue)
                            HStack {
                                Label("", systemImage: "moon.zzz")
                                Text(String(format: "%.1f", amountOfNeutral)+" h")
                            }.foregroundColor(.green)
                        }
                        
                    }
                }
                Section("현재 가격") {
                    Label(String(format: "%.0f", currentPrice), systemImage: "dollarsign.circle.fill")
                }
                miniBar(priceList: sortedPrice)
                    .scaledToFit()
                VStack {
                    MessageBox(message: "잠깐! 완성하기를 누르기 전에 그 날 자정부터 오후 11:59분까지 꼼꼼하게 일기를 작성했는지 확인해라!", leftSpeaker: true)
                    MessageBox(message: "오늘 일기를 먼저 쓰고 제출해버렸어. 어제 일기도 쓰고 싶은데, 그게 안되네...", leftSpeaker: false)
                    MessageBox(message: "날짜 선택은 최근 추가된 실적을 기준으로 범위가 제한된다! 이건 분식회계를 방지하기 위한 최소조치지.", leftSpeaker: true)
                }
            }
            .listStyle(.plain)
            HStack() {
                Button{
                    showAlert.toggle()
                } label: {
                    Text("완성하기")
                        .padding(.vertical,10)
                        .padding(.horizontal,15)
                        .background(viewModel.tempDiaryList.count > 0 ? Color.green:Color.gray)
                        .cornerRadius(45)
                }.disabled(viewModel.tempDiaryList.count > 0 ? false:true)
                Button{
                    undoAction()
                } label: {
                    Text("되돌리기")
                        .padding(.vertical,10)
                        .padding(.horizontal,15)
                        .background(viewModel.tempDiaryList.count > 0 ? Color.red:Color.gray)
                        .cornerRadius(45)
                }.disabled(viewModel.tempDiaryList.count > 0 ? false:true)
            }
            .padding(.vertical, 5)
            .font(.system(size: 15))
            .foregroundColor(Color.white)
        }
        .onAppear(){
            //자동으로 임시저장된 데이터를 불러온다.
            if viewModel.tempDiaryList.count > 0 {
                //1. 캘린더 날짜 선택기간 제한
                if viewModel.priceList.isEmpty == false {
                    viewModel.findRecentDay(completion: { message in
                        print(message)
                    })
                    //2. 전날 종가 불러오기
                    previousClose = viewModel.priceList.last!.close
                }
                //정렬하고 가격 리스트를 만든다.
                sortTempDiaryAndCreatePriceList()
                //4. 시간 세팅하기
                endTime = sortedDiary.last!.endTime
                startTime = endTime
                //5. 뷰 타이틀 변경하기
                date = endTime
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY.MM.dd.E"
                strDate = dateFormatter.string(from: date)
            } else {
                updateSelectedDate()
            }
        }
        .alert("잠깐! 이 날의 자정부터 오후 11:59분까지 꼼꼼하게 일기를 쓰셨나요? 제출하면 더 이상 수정은 불가합니다!", isPresented: $showAlert) {
            Button("제출") {
                //값 타입으로 전달하여 리스트가 초기화 될 때 비동기 처리에서 문제가 안생기게 하여야...
                //0. Firebase에 데이터 업로드
                let valDiaryList = sortedDiary
                viewModel.diaryAdd(diaryList: valDiaryList, completion: { message in
                    print(message)
                })
                let valPriceList = sortedPrice
                let idx: Double = Double(viewModel.priceList.count)
                let price = CandleChartDataEntry(x: idx, shadowH: valPriceList.max()!, shadowL: valPriceList.min()!, open: valPriceList.first!, close: valPriceList.last!)
                viewModel.priceAdd(price: price, completion: { message in
                    print(message)
                })
                viewModel.findRecentDay(completion: { message in
                    print(message)
                })
                //자동으로 다음날 일과 추가할 수 있게
                date = date.addingTimeInterval(86400)
                if Calendar.current.startOfDay(for: date) < Date() { //오늘 일과까지 다 추가했다면 뷰 업데이트를 진행하지 않음.
                    updateSelectedDate()
                } else {
                    //임시 저장 삭제하기
                    viewModel.removeTemp()
                    viewModel.tempDiaryList.removeAll()
                    sortedDiary.removeAll()
                    sortedPrice.removeAll()
                }
                showSuccess.toggle()
            }
            Button("취소", role: .cancel) {
            }
        }
        .alert("날짜를 다시 선택하면 임시 저장된 데이터가 초기화됩니다. 계속하시겠습니까?", isPresented: $showCalendarAlert) {
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
        .sheet(isPresented: $showDiary, onDismiss: addDiary) {
            DiaryFieldView(story: $story, eval: $eval, showDiary: $showDiary, concentration: $concentration)
        }
        .toast(isPresenting: $showToast) {
            AlertToast(displayMode: .banner(.slide), type: .regular, title:"작성 완료! 다른 시간의 일기들도 작성해주세요.")
        }
        .toast(isPresenting: $showSuccess) {
            AlertToast(displayMode: .alert, type: .complete(.green), title: "실적 제출 성공!")
        }
        .toast(isPresenting: $showError) {
            AlertToast(displayMode: .alert, type: .error(.red), title: "중복된 시간!")
        }
    }
    /*
     날짜 선택시 네비게이션 타이틀 바를 업데이트하고,
     해당 날짜의 자정부터 시간을 선택할 수 있게 시간 세팅
     또한 다이어리, 가격 리스트 초기화
     */
    func updateSelectedDate(){
        //0. 임시 저장된 데이터 삭제하기 (날짜를 새로 선택했으므로)
        if viewModel.tempDiaryList.isEmpty == false {
            viewModel.removeTemp()
            viewModel.tempDiaryList.removeAll()
            sortedDiary.removeAll()
            sortedPrice.removeAll()
        }
        //1. 캘린더 날짜 선택기간 제한
        if viewModel.priceList.isEmpty == false {
            viewModel.findRecentDay(completion: { message in
                print(message)
            })
            //2. 전날 종가 불러오기
            previousClose = viewModel.priceList.last!.close
            //3. 임시저장된 데이터가 없으니 종가에서 현재가 그대로 설정
            currentPrice = previousClose
        }
        //4. 시간 세팅하기
        endTime = Calendar.current.startOfDay(for: date)
        startTime = endTime
        //5. 뷰 타이틀 변경하기
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd.E"
        strDate = dateFormatter.string(from: date)
    }
    func undoAction() {
        //1. 마지막 요소 pop
        viewModel.tempDiaryList.removeLast()
        //db에서도 pop
        viewModel.popTempDiary()
        //정렬하고 가격 리스트를 새로 만든다.
        sortTempDiaryAndCreatePriceList()
        //2. 시간 세팅하기
        endTime = viewModel.tempDiaryList.last?.endTime ?? Calendar.current.startOfDay(for: date)
        startTime = endTime
        story = ""
    }
    func addDiary() {
        //중복된 시간이 있는지 검사
        let timeRange = startTime..<endTime
        let duplicate = viewModel.tempDiaryList.filter{
            timeRange.overlaps($0.startTime..<$0.endTime)
        }
        if !duplicate.isEmpty {
            showError.toggle()
            return
        }
        //중복된 시간이 없다면 다이어리를 temp에 push하고
        let diary = Diary(story: story, startTime: startTime, endTime: endTime, eval: eval, concentration: concentration)
        viewModel.tempDiaryList.append(diary)
        //정렬하고 가격 리스트를 새로 만든다.
        sortTempDiaryAndCreatePriceList()
        //db에 임시 저장
        viewModel.addTempDiary()
        //시간 세팅
        startTime = endTime
        showToast.toggle()
        story = ""
    }
    func sortTempDiaryAndCreatePriceList() {
        sortedDiary = viewModel.tempDiaryList.sorted{ $0.startTime < $1.startTime }
        currentPrice = previousClose
        sortedPrice.removeAll()
        amountOfProductive = 0
        amountOfUnproductive = 0
        amountOfNeutral = 0
        for diary in sortedDiary {
            let time = diary.endTime.timeIntervalSince(diary.startTime) / 60
            let amount = time / 60
            let variance = previousClose * (time * 0.01) * 0.01
            switch diary.eval {
            case .productive:
                //집중도에 비례해서 가격이 올라감
                currentPrice += variance * concentration
                amountOfProductive += amount
            case .unproductive:
                //3배 곱해서 깎음...
                currentPrice -= variance * 3
                amountOfUnproductive += amount
            case .neutral:
                amountOfNeutral += amount
            case .cancel:
                story = ""
                return
            }
            sortedPrice.append(currentPrice)
        }
    }
}

struct EvaluationView_Previews: PreviewProvider {
    static var previews: some View {
        EvaluationView()
            .environmentObject(ViewModel())
    }
}
