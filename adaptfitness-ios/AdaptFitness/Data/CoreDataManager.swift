//
//  CoreDataManager.swift
//  AdaptFitness
//
//  Created by csuftitan on 11/15/25.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()

    let container: NSPersistentContainer

    // MARK: - Init
    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "AdaptFitnessModel") // match .xcdatamodeld name
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (desc, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            
            if let url = desc.url {
                    print("📌 Core Data Store Location:")
                    print(url.path)
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
    }

    // use this when creating an in-memory instance for tests
    static func previewManager() -> CoreDataManager {
        CoreDataManager(inMemory: true)
    }

    var viewContext: NSManagedObjectContext { container.viewContext }

    // MARK: - CRUD convenience methods
    func createFitnessRecord(from template: FitnessRecordTemplate, context: NSManagedObjectContext? = nil) throws {
        let ctx = context ?? viewContext
        let record = FitnessRecord(context: ctx)
        record.id = template.id ?? UUID()
        record.name = template.name
        record.intensity = template.intensity
        record.calories = template.calories
        record.duration = template.duration
        record.systemImage = template.systemImage
        record.date = template.date

        try ctx.save()
    }

    func delete(_ record: FitnessRecord, context: NSManagedObjectContext? = nil) throws {
        let ctx = context ?? viewContext
        ctx.delete(record)
        try ctx.save()
    }

    func fetchAllFitnessRecords(context: NSManagedObjectContext? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [FitnessRecord] {
        let ctx = context ?? viewContext
        let req: NSFetchRequest<FitnessRecord> = FitnessRecord.fetchRequest()
        req.sortDescriptors = sortDescriptors
        return try ctx.fetch(req)
    }
}
