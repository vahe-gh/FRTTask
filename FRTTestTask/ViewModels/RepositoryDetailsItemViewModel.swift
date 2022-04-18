//
//  RepositoryDetailsItemViewModel.swift
//  FRTTestTask
//
//  Created by Vahe Hakobyan on 18.04.22.
//

import Foundation

struct RepositoryDetailsItemViewModel {
    var language: String
    var description: String
    var creationDate: Date?
    var repositoryURL: URL?
    var isStarred: Bool = false
}
