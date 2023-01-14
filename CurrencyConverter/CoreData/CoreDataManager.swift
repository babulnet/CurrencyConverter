//
//  CoreDataManager.swift
//  CurrencyConverter
//
//  Created by Babul Raj on 29/12/22.
//

import Foundation
import CoreData

public extension NSManagedObject {
    static var entityName: String {
        return String(describing: self)
    }
}

class CoredataManager {
    public static var shared = CoredataManager()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "DataModel") // or use model Name
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchObjects<T: NSManagedObject>(attributes:[AnyHashable:Any], inputType:T.Type) -> [T]? {
        var predicates = [NSPredicate]()
        for (key,value) in attributes {
            let newPredicate = NSPredicate(format: "%K = %@", argumentArray: [key,value])
            predicates.append(newPredicate)
        }
        
        let comoundPredicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest(entityName: T.entityName)
        fetchRequest.predicate = comoundPredicate
        
        do {
            let result = try self.context.fetch(fetchRequest)
            return result
            
        } catch {
            print(error)
            return nil
        }
    }
}
