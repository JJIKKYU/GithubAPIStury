//
//  SearchViewModel.swift
//  githubAPI
//
//  Created by 정진균 on 2021/12/03.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class SearchViewModel {
    let searchBarRelay = BehaviorRelay<String>(value: "")
    let searchResult = BehaviorRelay<GitHubUserSearchModel>(value: GitHubUserSearchModel(login: "", avatarUrl: ""))
    let client = HttpClient.init(baseUrl: "https://api.github.com/users/")

    func SearchGitHub() {
        let searchStr: String = searchBarRelay.value
        print("serachSTr = \(searchStr)")
//        let result = client.fetchData(userName: searchBarRelay.value)
        HttpClient.shared.fetchData2(userName: searchStr) { response in
            switch response {
            case .success(let data):
                print(data)
                self.searchResult.accept(data)
            case .failure(let err):
                print(err)
            }
        }
    }
}
