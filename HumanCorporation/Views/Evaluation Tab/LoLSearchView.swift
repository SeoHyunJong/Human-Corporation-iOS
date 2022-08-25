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
    private let rgApiKey = "RGAPI-c23dcccc-903b-45b9-b4d7-2b3de3c96561"
    @State private var summon_name = ""
    @State private var puuid = ""
    @State private var matchList: [String] = []
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
                                loadMatch()
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
                    
                } label: {
                    Label("총 \(String(matchList.count))건의 비생산성 적발!", systemImage: "arrow.right.circle.fill")
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
    
    func loadMatch() {
        let startTime = String(format: "%.0f", Calendar.current.startOfDay(for: date).timeIntervalSince1970)
        print(startTime)
        guard let url = URL(string: "https://asia.api.riotgames.com/lol/match/v5/matches/by-puuid/\(puuid)/ids?startTime=\(startTime)&start=0&count=20&api_key=\(rgApiKey)") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                self.matchList.removeAll()
                if let response = try? JSONDecoder().decode([String].self, from: data) {
                    self.matchList = response
                    print(matchList)
                    return
                }
            }
        }.resume()
    }
}

struct LoLSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LoLSearchView(date: Date())
    }
}
