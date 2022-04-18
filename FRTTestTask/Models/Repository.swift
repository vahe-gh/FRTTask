//
//  Repository.swift
//  FRTTestTask
//
//  Created by Vahe Hakobyan on 16.04.22.
//

import Foundation

struct Repository: Decodable {
    let id: Int
    let name: String
    let owner: RepositoryOwner
}
