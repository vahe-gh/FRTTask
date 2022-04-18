//
//  RepositoryViewModel.swift
//  FRTTestTask
//
//  Created by Vahe Hakobyan on 17.04.22.
//

import Foundation

class RepositoryViewModel: NSObject {
    
    // MARK: - Properties
    
    private var modelData: [Repository]? = nil
    var totalCount: Int {
        return data.count == 0 ? 0 : data.count + 20
    }
    var data = [RepositoryItemViewModel]()
    var reloadUI: ((Error?) -> ())?
    
    // MARK: Infinite scrolling
    
//    private (set) var totalCount: Int = 0
    var indexPathsToReload: [IndexPath]? = nil
    private var currentPage = 1
    private var isFetchInProgress = false
    private var previousData = [RepositoryItemViewModel]()
    
    // MARK: - Data operations
    
    func getData(userName: String, pageNumber: Int? = nil, itemsPerPage: Int = 30) {
        guard !isFetchInProgress else {
            return
        }
        
        let pageNumber = pageNumber ?? currentPage
        
        guard let url = URL(string: "https://api.github.com/users/\(userName)/repos?type=owner&page=\(pageNumber)&per_page=\(itemsPerPage)") else {
            reloadUI?(AppError.cantGenerateURL)
            return
        }
        
        isFetchInProgress = true
        previousData = data
        
        APIService.shared.fetchData(sourcesURL: url, model: [Repository].self) { result in
            self.isFetchInProgress = false
            
            switch result {
            case .success(let response):
                self.data = response.map({ self.createViewModel(from: $0) })
                self.currentPage += 1
                self.appendFetchedData()
                self.reloadUI?(nil)
            case .failure(let error):
                self.reloadUI?(error)
            }
        }
    }
    
    private func createViewModel(from data: Repository) -> RepositoryItemViewModel {
        let avatarURL = URL(string: data.owner.avatarURL)
        let itemViewModel = RepositoryItemViewModel(
            userName: data.owner.login,
            repositoryName: data.name,
            avatar: avatarURL
        )
        return itemViewModel
    }
    
}

// MARK: - Infinite scrolling

private extension RepositoryViewModel {

    func calculateIndexPathsToReload(existingData: [RepositoryItemViewModel], newData: [RepositoryItemViewModel]) -> [IndexPath]? {
        guard existingData.count > 0 else {
            return nil
        }
        
        let startIndex = existingData.count - newData.count
        let endIndex = startIndex + newData.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    func appendFetchedData() {
        guard data.count > 0 else {
            indexPathsToReload = nil
            return
        }
        
        indexPathsToReload = calculateIndexPathsToReload(existingData: previousData, newData: data)
        data = previousData + data
    }
    
}
