//
//  BrowseView.swift
//  AdaptFitness
//
//  Created by csuftitan on 9/17/25.
//
//
//  BrowseWorkoutsView.swift
//  AdaptFitness
//

import SwiftUI

struct BrowseWorkoutsView: View {
    // Predefined workouts
    let workouts: [Workout] = [
        Workout(name: "Add Custom Workout", intensity: "", calories: "", systemImage: "plus.circle"),
        Workout(name: "Running", intensity: "High", calories: "352 per 30 min", systemImage: "figure.run"),
        Workout(name: "Walking", intensity: "Low", calories: "150 per 30 min", systemImage: "figure.walk"),
        Workout(name: "Swimming", intensity: "High", calories: "215 per 30 min", systemImage: "drop.fill"),
        Workout(name: "Cycling", intensity: "Low-High", calories: "225 per 30 min", systemImage: "bicycle"),
        Workout(name: "Hiking", intensity: "Low-Moderate", calories: "180 per 30 min", systemImage: "figure.hiking"),
        Workout(name: "Yoga", intensity: "Low-High", calories: "173 per 30 min", systemImage: "figure.cooldown"),
        Workout(name: "Boxing", intensity: "High", calories: "400 per 30 min", systemImage: "figure.boxing")
    ]
    
    // MARK: - State
    @State private var selectedWorkout: FitnessRecord? = nil
    @State private var showAddWorkoutSheet = false
    
    var body: some View {
        VStack {
            Text("Browse Workouts")
                .font(.largeTitle)
                .bold()
                .padding(.top, 20)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(workouts, id: \.name) { workout in
                        Button {
                            selectWorkout(workout)
                        } label: {
                            WorkoutTile(workout: workout)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
        }
        .sheet(isPresented: $showAddWorkoutSheet) {
            // Ensure we have a selectedWorkout before showing the form
            if let _ = selectedWorkout {
                AddWorkoutFormView(
                    record: Binding(
                        get: { selectedWorkout! },
                        set: { selectedWorkout = $0 }
                    )
                )
            }
        }
    }
    
    // MARK: - Helper
    private func selectWorkout(_ workout: Workout) {
        if workout.name == "Add Custom Workout" {
            // Blank workout
            selectedWorkout = FitnessRecord(
                name: "",
                intensity: "",
                calories: 0,
                duration: 0,
                systemImage: "plus.circle",
                date: Date()
            )
        } else {
            // Pre-fill from existing workout
            let caloriesValue = Double(workout.calories.split(separator: " ").first ?? "0") ?? 0
            selectedWorkout = FitnessRecord(
                name: workout.name,
                intensity: workout.intensity,
                calories: caloriesValue,
                duration: 30 * 60, // default 30 min
                systemImage: workout.systemImage,
                date: Date()
            )
        }
        showAddWorkoutSheet = true
    }
}

// MARK: - Workout Tile
struct WorkoutTile: View {
    let workout: Workout
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: workout.systemImage)
                .resizable()
                .scaledToFit()
                .frame(height: 60)
            
            Text(workout.name)
                .font(.headline)
                .foregroundColor(.primary) // ensures default text color
            
            if !workout.intensity.isEmpty {
                Text("Intensity: \(workout.intensity)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            if !workout.calories.isEmpty {
                Text("Est Cal: \(workout.calories)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 150)
//        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}
