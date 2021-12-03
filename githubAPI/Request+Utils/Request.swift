//
//  Request.swift
//  githubAPI
//
//  Created by 정진균 on 2021/12/03.
//

import Foundation
import RxSwift
import Alamofire

class HttpClient {
    
    static let shared: HttpClient = HttpClient(baseUrl: "https://api.github.com/users/")
    
    private var request: DataRequest? {
        didSet {
            oldValue?.cancel()
        }
    }
    
    private let baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func fetchData(userName: String) -> GitHubUserSearchModel? {
        var data: GitHubUserSearchModel?
        let url = baseUrl + userName
        print("url = \(url)")
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let res):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                    print("jsonData = \(jsonData)")
                    
                    let json = try JSONDecoder().decode(GitHubUserSearchModel.self, from: jsonData)
                    print("json = \(json)")
                    data = json
                }
                catch(let err) {
                    print(err.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
        
        return data
    }
    
    func fetchData2(userName: String, completionHandler: @escaping (Result<GitHubUserSearchModel, AFError>) -> Void) {
        self.request = AF.request("\(baseUrl)" + "\(userName)")
        self.request?.responseDecodable { (response: DataResponse<GitHubUserSearchModel, AFError>) in
            switch response.result {
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let err):
                completionHandler(.failure(err))
            }
        }
    }
    
    func downloadJson(_ url: String) -> Observable<GitHubUserSearchModel?> {
        return Observable.create { [weak self] emitter in
            let urlStr = self!.baseUrl + url
            print(urlStr)
            let url = URL(string: urlStr)!
            let task = URLSession.shared.dataTask(with: url) { data, response, err in
                guard err == nil else {
                    emitter.onError(err!)
                    return
                }
                
                guard let data = data,
                      let userData = try? JSONDecoder().decode(GitHubUserSearchModel.self, from: data) else {
                          emitter.onCompleted()
                          return
                      }
                
                emitter.onNext(userData)
                emitter.onCompleted()
            }
            
            task.resume()
            
            return Disposables.create() {
                task.cancel()
            }
        }
    }
    
    
}
