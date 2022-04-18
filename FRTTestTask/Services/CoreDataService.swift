//
//  CoreDataService.swift
//  FRTTestTask
//
//  Created by Vahe Hakobyan on 18.04.22.
//

import UIKit
import CoreData

enum FilterCondition: String {
    case equal = "="
    case notEqual = "!="
}

struct Filter {
    let fieldName: String
    let values: Any
    let condition: FilterCondition
}

class CoreDataService {
    
    private let appDelegate: AppDelegate?
    private let managedContext: NSManagedObjectContext?
    
    init() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate?.persistentContainer.viewContext
        /// For  updating data if its unique key already exists in database
        managedContext?.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType)
    }
    
    func fetchData<T: NSManagedObject>(model: T.Type, filters: [Filter]?) -> [T]? {
        guard let managedContext = managedContext else {
            return nil
        }
        
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        fetchRequest.predicate = CoreDataService.getFilters(parameters: filters)
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
        
        let entityName = T.description()
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)
        let record = T(entity: entity!, insertInto: managedContext)
        return record
    }
    
    func deleteRecords<T: NSManagedObject>(_ type: T.Type, filters: [Filter]?) -> Bool{
        guard let managedContext = managedContext else {
            return false
        }
        
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        fetchRequest.predicate = CoreDataService.getFilters(parameters: filters)
        
        do {
            let objects = try managedContext.fetch(fetchRequest)
            for object in objects {
                managedContext.delete(object)
            }
            try managedContext.save()
            
            return true
        } catch _ {
            return false
        }
        
    }
    
    func saveContext() {
        appDelegate?.saveContext()
    }
    
}

extension CoreDataService {
    
    static func getFilters(parameters: [Filter]?) -> NSCompoundPredicate? {
        guard let parameters = parameters else { return nil }
        
        var compound = [NSPredicate]()
        for filter in parameters {
            if type(of: filter.values) == Array<Any>.self {
                switch filter.condition {
                case .equal:
                    compound.append(NSPredicate(format: "\(filter.fieldName) IN %@", filter.values as! [NSObject]))
                case .notEqual:
                    compound.append(NSPredicate(format: "NOT \(filter.fieldName) IN %@", filter.values as! [NSObject]))
                }
            } else {
                switch filter.condition {
                case .equal:
                    compound.append(NSPredicate(format: "\(filter.fieldName) == %@", filter.values as! NSObject))
                case .notEqual:
                    compound.append(NSPredicate(format: "\(filter.fieldName) != %@", filter.values as! NSObject))
                }
            }
        }
        
        if compound.count > 0 {
            return NSCompoundPredicate(andPredicateWithSubpredicates: compound)
        }

        return nil
    }
    
}
