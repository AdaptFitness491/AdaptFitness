//
//  AddFitnessRecordViewModel.swift
//  AdaptFitness
//
//  Created by csuftitan on 11/15/25.
//

import Foundation
import Combine
import CoreData

class AddFitnessRecordViewModel: ObservableObject {
    @Published var saveError: Error?
    
    private let coreDataManager: CoreDataManager

    init(coreDataManager: CoreDataManager = .shared) {
        self.coreDataManager = coreDataManager
    }

    func save(record template: FitnessRecordTemplate) {
        do {
            try coreDataManager.createFitnessRecord(from: template)
            saveError = nil

            // DEBUG: fetch all saved records
            let records = try coreDataManager.viewContext.fetch(FitnessRecord.fetchRequest())
            print("DEBUG — total saved records:", records.count)

        } catch {
            saveError = error
            print("ERROR saving:", error)
        }
    }

    
}
