//
//  StarredRepositoryViewModel.swift
//  FRTTestTask
//
//  Created by Vahe Hakobyan on 18.04.22.
//

import Foundation
import CoreData

class StarredRepositoryViewModel: NSObject {
    
    // MARK: - Properties
    
    private var modelData: [StarredRepository]? = nil
    var data = [RepositoryItemViewModel]()
    var reloadUI: ((Error?) -> ())?
    
    private lazy var dataService: CoreDataService = {
        let service = CoreDataService()
        return service
    }()
    
    // MARK: - Data operations
    
    func getData() {
        guard let modelData = dataService.fetchData(model: StarredRepository.self, filters: nil) else {
            self.reloadUI?(nil)
            return
        }
        
        self.modelData = modelData
        data = modelData.map({ createViewModel(from: $0) })
        self.reloadUI?(nil)
    }
    
    func getData(withId id: Int64) -> RepositoryItemViewModel? {
        let filter = Filter(fieldName: "id", values: id, condition: .equal)
        guard let data = dataService.fetchData(model: StarredRepository.self, filters: [filter])?.first else {
            return nil
        }
        
        return createViewModel(from: data)
    }
    
    func save(data: RepositoryItemViewModel) -> Bool {
        guard let newRecord = dataService.addRecord(StarredRepository.self) else {
            return false
        }
        
        newRecord.id = data.id
        newRecord.repositoryName = data.repositoryName
        newRecord.userName = data.userName
        newRecord.avatarURL = data.avatar
        dataService.saveContext()
        
        return true
    }
    
    func delete(data: RepositoryItemViewModel) -> Bool {
        let filter = Filter(fieldName: "id", values: data.id, condition: .equal)
        return dataService.deleteRecords(StarredRepository.self, filters: [filter])
    }
    
    private func createViewModel(from data: StarredRepository) -> RepositoryItemViewModel {
        let itemViewModel = RepositoryItemViewModel(
            id: data.id,
            userName: data.userName ?? "",
            repositoryName: data.repositoryName ?? "",
            avatar: data.avatarURL
        )
        return itemViewModel
    }
    
}
