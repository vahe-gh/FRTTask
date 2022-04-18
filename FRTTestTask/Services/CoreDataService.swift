//
//  CoreDataService.swift
//  FRTTestTask
//
//  Created by Vahe Hakobyan on 18.04.22.
//

import UIKit
import CoreData

class CoreDataService {
    
    private let appDelegate: AppDelegate?
    private let managedContext: NSManagedObjectContext?
    
    init() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate?.persistentContainer.viewContext
        /// For  updating data if its unique key already exists in database
        managedContext?.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType)
    }
    
    func fetchData<T: NSManagedObject>(model: T.Type) -> [T]? {
        guard let managedContext = managedContext else {
            return nil
        }
        
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        if let result = try? managedContext.fetch(fetchRequest) {
            if( result.count > 0) {
                return result
            }
        }
        
        return nil
    }
    
    func addRecord<T: NSManagedObject>(_ type : T.Type) -> T? {
        guard let managedContext = managedContext else {
            return nil
        }
        
        let _entityName = T.description()
        let _entity = NSEntityDescription.entity(forEntityName: _entityName, in: managedContext)
        let _record = T(entity: _entity!, insertInto: managedContext)
        return _record
    }
    
    func saveContext() {
        appDelegate?.saveContext()
    }
    
}
