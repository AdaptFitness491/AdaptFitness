//
//  HomePageViewModel.swift
//  AdaptFitness
//
//  Created by csuftitan on 11/16/25.
//

import Foundation
import CoreData
import Combine

class HomePageViewModel: ObservableObject {
    @Published var recentRecords: [FitnessRecord] = []

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchRecentRecords()
    }

    func fetchRecentRecords(limit: Int = 7) {
        let request: NSFetchRequest<FitnessRecord> = FitnessRecord.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        request.fetchLimit = limit

        do {
            recentRecords = try context.fetch(request)
            print("Fetched \(recentRecords.count) recent workouts")
        } catch {
            print("Error fetching records: \(error)")
        }
    }
}
