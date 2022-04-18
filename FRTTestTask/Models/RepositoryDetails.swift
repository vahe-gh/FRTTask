//
//  RepositoryDetails.swift
//  FRTTestTask
//
//  Created by Vahe Hakobyan on 18.04.22.
//

import Foundation

struct RepositoryDetails: Decodable {
    let id: Int64
    let language: String
    let description: String
    let creationDate: String
    let repositoryURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case language
        case description
        case creationDate = "created_at"
        case repositoryURL = "html_url"
    }
}
