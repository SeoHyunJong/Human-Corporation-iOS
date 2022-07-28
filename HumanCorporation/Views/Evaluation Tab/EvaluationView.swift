//
//  EvaluationView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/07/19.
//
/*
 실적을 제출하거나 다시 작성 버튼을 누르면 다이어리 리스트, 가격 리스트가 초기화 되어야 한다.
 다른 날짜를 선택할 때에도 다이어리, 가격 리스트가 초기화 되어야 한다.
 **참고: Swift의 Array는 구조체로 구현되어 있어 값타입 -> 복사할때 서로 영향 X
 그러나 요소에 값 타입이 아닌 참조 타입이 들어간 경우 복사할 때 영향이 있다고 한다.
 이미 오늘 날짜까지 일정을 추가한 경우 (viewModel >= Date()) "추가할 실적이 없네요..." 라는 뷰가 떠야 한다.
 
 임시저장: 임시 다이어리, 가격 리스트를 db에 따로 저장했다가 onAppear 에서 불러오는 게 가능.
 유저가 최종 발행할때 이 임시 데이터들은 삭제됨.
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
    
    @State private var story = ""
    @State private var eval = Diary.Evaluation.cancel
    
    @State private var showToast = false
    @State private var showSuccess = false
    @State private var showDiary = false
    @State private var showAlert = false
    @State private var showPortAlert = false
    @State private var showTempAlert = false
    
    @EnvironmentObject var viewModel: ViewModel
    @State private var diaryList:[Diary] = []
    @State private var priceList:[Double] = []
    @State private var previousClose: Double = 1000
    @State private var currentPrice: Double = 1000
    
    var body: some View {
        NavigationView{
            VStack(alignment: .center) {
                Form{
                    Section("시간별로 일기를 작성하여 실적을 완성하세요!") {
                        DatePicker("시작 시간", selection: $startTime, in: pickStart...pickStart)
                        DatePicker("종료 시간", selection: $endTime, in: pickStart...Date())
                        HStack {
                            Label(String(format: "%.0f", endTime.timeIntervalSince(startTime) / 60)+" min", systemImage: "clock")
                            Spacer()
                            Button {
                                eval = .cancel
                                showDiary.toggle()
                            } label: {
                                Label("미니 일기 작성", systemImage: "plus.circle.fill")
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            .disabled(endTime.timeIntervalSince(startTime) > 0 ? false:true)
                        }
                    }
                    Section("현재 가격") {
                        Label(String(format: "%.0f", currentPrice), systemImage: "dollarsign.circle.fill")
                    }
                    miniBar(priceList: priceList)
                        .frame(width: 300, height: 300, alignment: .center)
                }
                HStack() {
                    Button{
                        showAlert.toggle()
                    } label: {
                        Text("완성하기")
                            .font(.system(size: 15))
                            .foregroundColor(Color.white)
                            .padding(.vertical,10)
                            .padding(.horizontal,15)
                            .background(priceList.count > 0 ? Color.blue:Color.gray)
                            .cornerRadius(45)
                    }.disabled(priceList.count > 0 ? false:true)
                    Button{
                        showTempAlert.toggle()
                    } label: {
                        Text("임시저장")
                            .font(.system(size: 15))
                            .foregroundColor(Color.white)
                            .padding(.vertical,10)
                            .padding(.horizontal,15)
                            .background(priceList.count > 0 ? Color.green:Color.gray)
                            .cornerRadius(45)
                    }.disabled(priceList.count > 0 ? false:true)
                    Button{
                        showPortAlert.toggle()
                    } label: {
                        Text("불러오기")
                            .font(.system(size: 15))
                            .foregroundColor(Color.white)
                            .padding(.vertical,10)
                            .padding(.horizontal,15)
                            .background(viewModel.tempPriceList.count > 0 && viewModel.tempDiaryList.count > 0 ? Color.yellow:Color.gray)
                            .cornerRadius(45)
                    }.disabled(viewModel.tempPriceList.count > 0 && viewModel.tempDiaryList.count > 0 ? false:true)
                    Button{
                        undoAction()
                    } label: {
                        Text("되돌리기")
                            .font(.system(size: 15))
                            .foregroundColor(Color.white)
                            .padding(.vertical,10)
                            .padding(.horizontal,15)
                            .background(priceList.count > 0 ? Color.red:Color.gray)
                            .cornerRadius(45)
                    }.disabled(priceList.count > 0 ? false:true)
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
            viewModel.readTempDiaryList()
            viewModel.readTempPriceList()
            updateSelectedDate()
        }
        .alert("정말 모든 시간의 일기를 작성하셨나요? 제출하면 더 이상 수정은 불가합니다!", isPresented: $showAlert) {
            Button("제출") {
                //값 타입으로 전달하여 리스트가 초기화 될 때 비동기 처리에서 문제가 안생기게 하여야...
                let valDiaryList = diaryList
                viewModel.diaryAdd(diaryList: valDiaryList)
                
                let valPriceList = priceList
                let price = CandleChartDataEntry(x: 0, shadowH: valPriceList.max()!, shadowL: valPriceList.min()!, open: valPriceList.first!, close: valPriceList.last!)
                viewModel.priceAdd(price: price)
                
                viewModel.findRecentDay()
                date = date.addingTimeInterval(86400) //자동으로 다음날 일과 추가할 수 있게
                if date < Date() { //오늘 일과까지 다 추가했다면 뷰 업데이트를 진행하지 않음.
                    updateSelectedDate()
                }
                
                viewModel.tempDiaryList.removeAll()
                viewModel.tempPriceList.removeAll()
                viewModel.removeTemp()
                
                showSuccess.toggle()
            }
            Button("취소", role: .cancel) {
            }
        }
        .alert("작성한 일기들을 임시 저장할까요?", isPresented: $showTempAlert) {
            Button("확인") {
                viewModel.removeTemp()
                
                viewModel.addTempDiaryList(diaryList: diaryList)
                viewModel.addTempPriceList(priceList: priceList)
                
                viewModel.tempPriceList = priceList
                viewModel.tempDiaryList = diaryList
            }
            Button("취소", role: .cancel) {
            }
        }
        .alert("임시 저장된 일기들을 불러올까요?", isPresented: $showPortAlert) {
            Button("확인") {
                diaryList = viewModel.tempDiaryList
                priceList = viewModel.tempPriceList
                
                currentPrice = priceList.last!
                endTime = diaryList.last!.endTime
                pickStart = endTime
                startTime = endTime
                
                date = endTime
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY.MM.dd.E"
                strDate = dateFormatter.string(from: date)
            }
            Button("취소", role: .cancel) {
            }
        }
        .sheet(isPresented: $showCalendar, onDismiss: updateSelectedDate){
            DatePicker("날짜를 고르세요.", selection: $date, in: viewModel.recentDay...Date(), displayedComponents: [.date])
                .datePickerStyle(.graphical)
        }
        .sheet(isPresented: $showDiary, onDismiss: addDiary) {
            DiaryFieldView(story: $story, eval: $eval, showDiary: $showDiary)
        }
        .toast(isPresenting: $showToast) {
            AlertToast(displayMode: .banner(.slide), type: .regular, title:"작성 완료! 다른 시간의 일기들도 작성해주세요.")
        }
        .toast(isPresenting: $showSuccess) {
            AlertToast(displayMode: .alert, type: .complete(.green), title: "실적 제출 성공!")
        }
    }
    /*
     날짜 선택시 네비게이션 타이틀 바를 업데이트하고,
     해당 날짜의 자정부터 시간을 선택할 수 있게 시간 세팅
     또한 다이어리, 가격 리스트 초기화
     */
    func updateSelectedDate(){
        if viewModel.priceList.isEmpty == false {
            viewModel.findRecentDay() //유저가 캘린더에서 과거의 일자를 선택 못하도록 제한
            previousClose = viewModel.priceList.last!.close
            currentPrice = previousClose
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd.E"
        strDate = dateFormatter.string(from: date)
        
        startTime = Calendar.current.startOfDay(for: date)
        endTime = Calendar.current.startOfDay(for: date)
        pickStart = Calendar.current.startOfDay(for: date)
        
        diaryList.removeAll()
        priceList.removeAll()
    }
    func undoAction() {
        diaryList.removeLast()
        priceList.removeLast()
        
        endTime = diaryList.last?.endTime ?? Calendar.current.startOfDay(for: date)
        pickStart = endTime
        startTime = endTime
        
        currentPrice = priceList.last ?? previousClose
        story = ""
    }
    func addDiary() {
        let time = endTime.timeIntervalSince(startTime) / 60
        let variance = previousClose * (time * 0.04) * 0.01
        
        switch eval {
        case .productive:
            currentPrice += variance
        case .unproductive:
            currentPrice -= variance
        case .neutral: break
        case .cancel:
            story = ""
            return
        }
        
        let diary = Diary(story: story, startTime: startTime, endTime: endTime, eval: eval)
        self.priceList.append(currentPrice)
        self.diaryList.append(diary)
        pickStart = endTime
        startTime = endTime
        showToast.toggle()
        story = ""
    }
}

struct EvaluationView_Previews: PreviewProvider {
    static var previews: some View {
        EvaluationView()
            .environmentObject(ViewModel())
    }
}
