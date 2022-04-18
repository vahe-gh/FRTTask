//
//  RepositoryDetailsViewModel.swift
//  FRTTestTask
//
//  Created by Vahe Hakobyan on 18.04.22.
//

import Foundation

class RepositoryDetailsViewModel: NSObject {
    
    // MARK: - Properties
    
    private var modelData: RepositoryDetails? = nil
    var data: RepositoryDetailsItemViewModel?
    var reloadUI: ((Error?) -> ())?
    
    // MARK: - Data operations
    
    func getData(userName: String, repositoryName: String) {
        guard !userName.isEmpty else {
            reloadUI?(AppError.blankUsername)
            return
        }
        guard !repositoryName.isEmpty else {
            reloadUI?(AppError.blankRepository)
            return
        }
        guard let url = URL(string: "https://api.github.com/repos/\(userName)/\(repositoryName)") else {
            reloadUI?(AppError.cantGenerateURL)
            return
        }
        
        APIService.shared.fetchData(sourcesURL: url, model: RepositoryDetails.self) { result in
            switch result {
            case .success(let response):
                self.data = self.createViewModel(from: response)
                self.reloadUI?(nil)
            case .failure(let error):
                self.reloadUI?(error)
            }
        }
    }
    
    private func createViewModel(from data: RepositoryDetails) -> RepositoryDetailsItemViewModel {
        let repositoryURL = URL(string: data.repositoryURL)
        let creationDate = Date(from: data.creationDate)
        
        let itemViewModel = RepositoryDetailsItemViewModel(
            language: data.language,
            description: data.description,
            creationDate: creationDate,
            repositoryURL: repositoryURL)
        return itemViewModel
    }
    
}
