//
//  CommitDiary.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/08/17.
//

import SwiftUI

struct CommitDiary: View {
    @State private var commitList = [Commit]()
    @State private var commitDiaryList = [Diary]()
    @State private var dateFormatter = DateFormatter()
    @FocusState private var storyFocused: Bool
    
    var date: Date
    var repoName: String
    var ownerName: String
    var committer: String
    
    var body: some View {
        VStack {
            Text("시작시간을 재설정하세요!")
            List {
                ForEach($commitDiaryList, id: \.self) { $diary in
                    Section {
                        VStack {
                            HStack{
                                TextEditor(text: $diary.story)
                                    .focused($storyFocused)
                                    .padding()
                                Divider()
                                VStack(alignment: .trailing){
                                    Text("시작")
                                        .foregroundColor(.secondary)
                                    DatePicker("", selection: $diary.startTime, displayedComponents: [.hourAndMinute])
                                    Text("종료")
                                        .foregroundColor(.secondary)
                                    Text(dateFormatter.string(from:diary.endTime))
                                }
                                .frame(width:120)
                            }
                            Slider(value: $diary.concentration, in: 1...4, step: 1)
                                .tint(.green)
                            Button{
                                
                            } label: {
                                Label("submit", systemImage: "arrow.right.circle.fill")
                            }
                        }
                    }
                }
            }
            .onTapGesture {
                storyFocused = false
            }
            .onAppear(){
                dateFormatter.dateFormat = "HH:mm"
                loadData(completion: { message in
                    print(message)
                    sortCommit()
                })
        }
        }
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
                    DispatchQueue.main.async {
                        self.commitList = response
                        completion("커밋기록 가져오기 성공")
                    }
                    return
                }
            }
        }.resume()
    }
}

struct CommitDiary_Previews: PreviewProvider {
    static var previews: some View {
        CommitDiary(date: Date(), repoName: "Human-Corporation-iOS", ownerName: "SeoHyunJong", committer: "SeoHyunJong")
    }
}
