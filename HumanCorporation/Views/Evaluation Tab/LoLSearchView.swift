//
//  LoLSearchView.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/08/25.
//
//KT Way
//RGAPI-c23dcccc-903b-45b9-b4d7-2b3de3c96561

import SwiftUI

struct LoLSearchView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    private let rgApiKey = "RGAPI-b79535a6-0fe4-4b47-83a9-58349fc392fd"
    @State private var summon_name = ""
    @State private var puuid = ""
    @State private var matchList: [String] = []
    @State private var fetchCounter = 0
    @FocusState private var focused: Bool
    var date: Date
    
    var body: some View {
        VStack {
            ScrollView{
                VStack{
                    Image("LoL_title")
                        .resizable()
                        .frame(width: 300, height: 115)
                    Divider()
                        .padding()
                    VStack(alignment: .leading){
                        Text("소환사명을 입력하세요!(KR서버)")
                        Text("휴코앱이 당신의 전적을 추적하여,")
                        Text("그 시간대를 비생산적(?)일로 추가해줍니다!")
                    }
                    .padding()
                    .foregroundColor(.secondary)
                    .font(.system(size: 18))
                }
                .padding()
                
                ZStack {
                    Rectangle()
                        .fill(.clear)
                        .border(.orange, width: 2)
                    HStack {
                        Text("Name")
                            .bold()
                            .foregroundColor(.orange)
                        Divider()
                        TextField("소환사 이름을 입력하세요!", text: $summon_name)
                            .focused($focused)
                        Button {
                            loadData(completion: { message in
                                print(message)
                                matchList.removeAll()
                                fetchCounter = 1
                                loadMatch(completion: { message in
                                    print(message)
                                    fetchCounter += 1
                                })
                            })
                        } label: {
                            Label("", systemImage: "magnifyingglass")
                                .tint(.orange)
                        }
                    }
                    .padding()
                }
                .frame(width: 300, height: 44)
                Button{
                    for match in matchList {
                        addDiary(matchID: match)
                    }
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    if fetchCounter == 1 {
                        Text("데이터를 불러오는 중...")
                    } else if fetchCounter == 2{
                        Label("총 \(String(matchList.count))건의 비생산성 적발!", systemImage: "arrow.right.circle.fill")
                    }
                }
                .padding()
                .disabled(matchList.isEmpty ? true:false)
            }
        }
        .onTapGesture {
            focused = false
        }
    }
    func loadData(completion: @escaping (_ message: String) -> Void) {
        let urlName = summon_name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: "https://kr.api.riotgames.com/lol/summoner/v4/summoners/by-name/\(urlName)?api_key=\(rgApiKey)") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode(Summoner.self, from: data) {
                    self.puuid = response.puuid
                    completion("유저의 롤 puuid 가져오기 성공!")
                    return
                }
            }
        }.resume()
    }
    
    func loadMatch(completion: @escaping (_ message: String) -> Void) {
        let startTime = String(format: "%.0f", Calendar.current.startOfDay(for: date).timeIntervalSince1970)
        print(startTime)
        guard let url = URL(string: "https://asia.api.riotgames.com/lol/match/v5/matches/by-puuid/\(puuid)/ids?startTime=\(startTime)&start=0&count=20&api_key=\(rgApiKey)") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([String].self, from: data) {
                    DispatchQueue.global(qos: .userInteractive).sync {
                        self.matchList = response
                    }
                    completion("유저의 롤 경기기록 가져오기 성공!")
                    return
                }
            }
        }.resume()
    }
    
    func addDiary(matchID: String) {
        guard let url = URL(string: "https://asia.api.riotgames.com/lol/match/v5/matches/\(matchID)?api_key=\(rgApiKey)")
        else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode(Match.self, from: data) {
                    DispatchQueue.main.async {
                        let startTime = Date(timeIntervalSince1970: Double(response.info.gameStartTimestamp)*0.001)
                        let endTime = Date(timeIntervalSince1970: Double(response.info.gameEndTimestamp)*0.001)
                        let timeRange = startTime..<endTime
                        let duplicate = viewModel.tempDiaryList.filter{
                            timeRange.overlaps($0.startTime..<$0.endTime)
                        }
                        if duplicate.isEmpty {
                            let diary = Diary(story: "사회악(?) 리그 오브 레전드 플레이!", startTime: startTime, endTime: endTime, eval: .unproductive, concentration: 2)
                            //중복된 시간이 없다면 다이어리를 temp에 push하고
                            viewModel.tempDiaryList.append(diary)
                            //정렬하고 가격 리스트를 새로 만든다.
                            //db에 임시 저장
                            viewModel.addTempDiary()
                            //시간 세팅
                        }
                    }
                    return
                }
            }
        }.resume()
    }
}

struct LoLSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LoLSearchView(date: Date())
            .environmentObject(ViewModel())
    }
}
