//
//  DataController.swift
//  EBookNote
//
//  Created by Nguyen Huu Hung on 7/7/24.
//

import Foundation
import CoreData

class DataController {
    
    static let shared = DataController(modelName: "EBookNote")
    
    let persistentContanier: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContanier.viewContext
    }
    
    init(modelName: String) {
        persistentContanier = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContanier.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
        }
    }
}
