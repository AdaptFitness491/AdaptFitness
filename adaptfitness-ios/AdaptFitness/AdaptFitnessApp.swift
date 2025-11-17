//
//  AdaptFitnessApp.swift
//  AdaptFitness
//
//  Created by csuftitan on 9/15/25.
//

import SwiftUI

@main
struct AdaptFitnessApp: App {
    @State private var isLoggedIn: Bool = false
    let coreDataManager = CoreDataManager.shared
    
    var body: some Scene {
        WindowGroup {
            
            if isLoggedIn {
                ContentView()
                    .environment(\.managedObjectContext, coreDataManager.viewContext)
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
            }
        }
    }
}
