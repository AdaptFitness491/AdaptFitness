//
//  AddWorkoutForm.swift
//  AdaptFitness
//
//  Created by csuftitan on 10/10/25.
//

import SwiftUI

struct AddWorkoutFormView: View {
    @State var workout: Workout

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Workout Details")) {
                    TextField("Workout Name", text: $workout.name)
                    TextField("Intensity", text: $workout.intensity)
                    TextField("Calories", text: $workout.calories)
                }
            }
            .navigationTitle(workout.name.isEmpty ? "Add Custom Workout" : "Edit Workout")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // save logic
                    }
                }
            }
        }
    }
}
