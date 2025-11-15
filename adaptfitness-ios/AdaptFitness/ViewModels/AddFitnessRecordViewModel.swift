//
//  AddFitnessRecordViewModel.swift
//  AdaptFitness
//
//  Created by csuftitan on 11/15/25.
//

import SwiftUI
import Foundation
import CoreData

class AddFitnessRecordViewModel: ObservableObject {

    private let coreDataManager: CoreDataManager

    init(coreDataManager: CoreDataManager = .shared) {
        self.coreDataManager = coreDataManager
    }

    func save(record template: FitnessRecordTemplate) -> Result<Void, Error> {
        do {
            try coreDataManager.createFitnessRecord(from: template)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
