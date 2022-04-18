//
//  RepositoryOwner.swift
//  FRTTestTask
//
//  Created by Vahe Hakobyan on 16.04.22.
//

import Foundation

struct RepositoryOwner: Decodable {
    let login: String
    let avatarURL: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
    }
}
