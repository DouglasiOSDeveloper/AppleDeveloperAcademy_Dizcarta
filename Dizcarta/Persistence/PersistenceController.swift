//
//  PersistenceController.swift
//  Dizcarta
//
//  Created by Felipe Brigagão de Almeida on 19/09/22.
//

import CoreData

class PersistenceController {
    static let context = PersistenceController().container.viewContext
    static let inMemoryContext = PersistenceController(inMemory: true).container.viewContext
    
    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Dizcarta")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
