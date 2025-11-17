//
//  RecentWorkoutTile.swift
//  AdaptFitness
//
//  Created by csuftitan on 11/16/25.
//

import SwiftUI

struct RecentWorkoutTile: View {
    let record: FitnessRecord

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(){
                Image(systemName: record.systemImage ?? "questionmark.circle")
                Text(record.name ?? "Workout")
                    .font(.headline)
            }
           

            Text("\(Int(record.calories)) kcal")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text(formattedDate(record.date ?? Date()))
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(width: 160, height: 120)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 3)
    }

    private func formattedDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: date)
    }
}
