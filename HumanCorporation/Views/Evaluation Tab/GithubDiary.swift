//
//  GithubDiary.swift
//  HumanCorporation
//
//  Created by 서현종 on 2022/08/17.
//

import SwiftUI

struct GithubDiary: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var ownerName: String = ""
    @State private var committerName: String = ""
    @State private var reposName: String = ""
    @State private var repoList = [TaskEntry]()
    @FocusState private var focused: Bool
    @State private var showCommitDiary = false
    
    var date: Date
    
    var body: some View {
        ScrollView {
            if showCommitDiary {
                CommitDiary(date: date, repoName: reposName, ownerName: ownerName, committer: committerName)
            } else {
                Group {
                    VStack(alignment: .center, spacing: 15) {
                        HStack {
                            Image(colorScheme == .dark ? "octocat_light" : "octocat_dark")
                                .resizable()
                                .frame(width: 100, height: 100)
                            Image(colorScheme == .dark ? "github_light" : "github_dark")
                                .resizable()
                                .frame(width: 200, height: 82)
                        }
                        .padding()
                        Text("개발자들을 위한 특별한 기능!")
                            .bold()
                            .font(.system(size: 20))
                        Text("Github에 있는 커밋 기록을 불러와 \n일기를 작성합니다.")
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                        Text("(Public Repositories만 지원됩니다.)")
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                        Divider()
                            .padding()
                        ZStack {
                            HStack {
                                Text("Owner")
                                Divider()
                                TextField("저장소 소유자 이름", text: $ownerName)
                                    .focused($focused)
                            }
                            .padding()
                            Rectangle()
                                .fill(.clear)
                                .border(.secondary, width: 1)
                        }
                        .padding()
                        .frame(width: 300, height: 50)
                        
                        ZStack {
                            HStack {
                                Text("Committer")
                                Divider()
                                TextField("커밋한 사람", text: $committerName)
                                    .focused($focused)
                            }
                            .padding()
                            Rectangle()
                                .fill(.clear)
                                .border(.secondary, width: 1)
                        }
                        .padding()
                        .frame(width: 300, height: 50)
                        
                        ZStack {
                            HStack {
                                Text("Repos")
                                Divider()
                                Menu("저장소를 선택하세요.") {
                                    ForEach(repoList, id: \.id) { repo in
                                        Button(repo.name){
                                            reposName = repo.name
                                            showCommitDiary.toggle()
                                            print("저장소 이름: \(reposName)")
                                        }
                                    }
                                }
                                Spacer()
                            }
                            .padding()
                            Rectangle()
                                .fill(.clear)
                                .border(.secondary, width: 1)
                        }
                        .padding()
                        .frame(width: 300, height: 50)
                    }
                }
            }
        }
        .onTapGesture {
            focused = false
            committerName = ownerName
            loadData()
        }
        .listStyle(.plain)
    }
    
    func loadData() {
        guard let url = URL(string: "https://api.github.com/users/\(ownerName)/repos") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([TaskEntry].self, from: data) {
                    DispatchQueue.main.async {
                        self.repoList = response
                    }
                    return
                }
            }
        }.resume()
    }
}

struct GithubDiary_Previews: PreviewProvider {
    static var previews: some View {
        GithubDiary(date: Date())
    }
}
