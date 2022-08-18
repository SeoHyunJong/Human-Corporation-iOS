//
//  CommitDiary.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/08/17.
//

import SwiftUI
import AlertToast

struct CommitDiary: View {
    @State private var commitList = [Commit]()
    @State private var commitDiaryList = [Diary]()
    @State private var dateFormatter = DateFormatter()
    @FocusState private var storyFocused: Bool
    @EnvironmentObject var viewModel: ViewModel
    @State var fetchCounter:Double = 0
    
    var date: Date
    var repoName: String
    var ownerName: String
    var committer: String
    
    var body: some View {
        VStack {
            if fetchCounter == 0 {
                LoadingView(fetchCounter: fetchCounter, completeNumber: 1)
            } else if fetchCounter == 1 {
                MessageBox(message: "추가하기 전에 시작시간 재설정이 필요하다!", leftSpeaker: true)
                List(commitDiaryList.indices, id: \.self) { idx in
                    Section {
                        VStack {
                            HStack{
                                TextEditor(text: $commitDiaryList[idx].story)
                                    .focused($storyFocused)
                                    .padding()
                                Divider()
                                VStack(alignment: .trailing){
                                    Text("시작")
                                        .foregroundColor(.secondary)
                                    DatePicker("", selection: $commitDiaryList[idx].startTime, in: ...commitDiaryList[idx].endTime, displayedComponents: [.hourAndMinute])
                                    Text("종료")
                                        .foregroundColor(.secondary)
                                    Text(dateFormatter.string(from:commitDiaryList[idx].endTime))
                                }
                                .frame(width: 100, height: 120)
                            }
                            VStack(alignment: .leading){
                                Text("집중도(생산성)")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: 15))
                                Slider(value: $commitDiaryList[idx].concentration, in: 1...4, step: 1)
                                    .tint(.green)
                            }
                            Button{
                                addDiary(diary: commitDiaryList[idx])
                            } label: {
                                Label("submit", systemImage: "arrow.right.circle.fill")
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            .disabled(isDuplicate(diary: commitDiaryList[idx]) ? true : false)
                        }
                    }
                }
                .onTapGesture {
                    storyFocused = false
                }
                
            }
        }
        .onAppear(){
            fetchCounter = 0
            dateFormatter.dateFormat = "HH:mm"
            loadData(completion: { message in
                print(message)
                sortCommit()
                print(commitDiaryList)
                fetchCounter += 1
            })
        }
    }
    func isDuplicate(diary: Diary)->Bool {
        //액션이 취소라면 무시
        //중복된 시간이 있는지 검사
        let timeRange = diary.startTime..<diary.endTime
        let duplicate = viewModel.tempDiaryList.filter{
            timeRange.overlaps($0.startTime..<$0.endTime)
        }
        if !duplicate.isEmpty {
            return true
        } else {
            return false
        }
    }
    func addDiary(diary: Diary) {
        //중복된 시간이 없다면 다이어리를 temp에 push하고
        viewModel.tempDiaryList.append(diary)
        //정렬하고 가격 리스트를 새로 만든다.
        //db에 임시 저장
        viewModel.addTempDiary()
        //시간 세팅
    }
    func sortCommit() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let thisDay = Calendar.current.startOfDay(for: date)
        commitDiaryList = commitList.filter{
            Calendar.current.startOfDay(for: dateFormatter.date(from: $0.commit.committer.date)!) == thisDay && $0.commit.committer.name == committer
        }.map{
            let endTime = dateFormatter.date(from: $0.commit.committer.date)!
            let startTime = endTime.addingTimeInterval(-3600)
            return Diary(story: $0.commit.message, startTime: startTime, endTime: endTime, eval: .productive)
        }
    }
    
    func loadData(completion: @escaping (_ message: String) -> Void) {
        guard let url = URL(string: "https://api.github.com/repos/\(ownerName)/\(repoName)/commits") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([Commit].self, from: data) {
                    DispatchQueue.global(qos: .userInteractive).sync {
                        self.commitList = response
                    }
                    completion("커밋 기록 가져오기 성공")
                    return
                }
            }
        }.resume()
    }
}

struct CommitDiary_Previews: PreviewProvider {
    static var previews: some View {
        CommitDiary(date: Date().addingTimeInterval(-86400), repoName: "Human-Corporation-iOS", ownerName: "SeoHyunJong", committer: "SeoHyunJong")
            .environmentObject(ViewModel())
    }
}
