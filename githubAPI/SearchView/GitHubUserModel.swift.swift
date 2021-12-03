//
//  GitHubUserModel.swift.swift
//  githubAPI
//
//  Created by 정진균 on 2021/12/03.
//

import Foundation

struct GitHubUserSearchModel: Codable {
    var login: String
    var avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
    
    init(login: String, avatarUrl: String) {
        self.login = login
        self.avatarUrl = avatarUrl
    }
}


struct GitHubUserDetailModel: Codable {
    var login: String
    var avatarUrl: String
    var name: String
    var bio: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
        case name
        case bio
    }
}
