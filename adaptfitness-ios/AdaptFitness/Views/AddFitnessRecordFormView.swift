//
//  AddWorkoutForm.swift
//  AdaptFitness
//
//  Created by csuftitan on 10/10/25.
//

import SwiftUI

struct AddFitnessRecordFormView: View {
    @Binding var record: FitnessRecordTemplate
    @StateObject private var viewModel = AddFitnessRecordViewModel()
    @Environment(\.presentationMode) private var presentationMode
    @State private var useStopwatch: Bool = false
    @State private var timerRunning: Bool = false
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var manualDuration: String = "00:00.000" // mm:ss.SSS format
    @State private var manualDate: Date = Date()
    
    var body: some View {
        VStack(spacing: 30) {
            
            // Workout Name
            TextField("Workout Name", text: $record.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            // Intensity Picker
            Picker("Intensity", selection: $record.intensity) {
                Text("Low").tag("Low")
                Text("Medium").tag("Medium")
                Text("High").tag("High")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .onChange(of: record.intensity) { _ in
                updateCalories()
            }
            
            // Stopwatch / Manual Toggle
            Picker("Time Input", selection: $useStopwatch) {
                Text("Manual").tag(false)
                Text("Stopwatch").tag(true)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            // Duration Input Section
            VStack(spacing: 20) {
                if useStopwatch {
                    // Stopwatch display
                    Text(formattedTime(elapsedTime))
                        .font(.system(size: 32, weight: .bold, design: .monospaced))
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 40) {
                        if !timerRunning {
                            Button(action: startTimer) {
                                Text("Start")
                                    .bold()
                                    .frame(width: 100, height: 50)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                        
                        if timerRunning {
                            Button(action: stopTimer) {
                                Text("Stop")
                                    .bold()
                                    .frame(width: 100, height: 50)
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                } else {
                    // Manual input
                    VStack(spacing: 10) {
                        HStack(spacing: 10) {
                            VStack(spacing: 10){
                                
                                TextField("mm:ss.SSS", text: $manualDuration)
                                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                                    .multilineTextAlignment(.center)
                                    .frame(width: 250)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numbersAndPunctuation)
                                    .onChange(of: manualDuration) { newValue in
                                        elapsedTime = parseManualDuration(newValue)
                                        record.duration = elapsedTime
                                        updateCalories()
                                    }
                                Text("Duration:")
                                    .font(.headline)
                            }
                            
                        }
                        
                        
                        // Manual Date Picker
                        DatePicker("Date", selection: $manualDate, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact)
                            .onChange(of: manualDate) { newDate in
                                record.date = newDate
                            }
                            .padding(.horizontal, 60)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            
            // Estimated Calories
            Text("Estimated Calories: \(Int(record.calories)) kcal")
                .font(.title2)
                .bold()
            
            Button(action: {
                // TODO: implement save action
                let result = viewModel.save(record: record)
                    switch result {
                    case .success:
                        presentationMode.wrappedValue.dismiss()
                    case .failure(let error):
                        // show error UI - for now print
                        print("Save failed: \(error)")
                    }
            }) {
                Text("Save")
                    .bold()
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .onDisappear {
            stopTimer()
        }
        .padding(.top, 20)
    }
    
    // MARK: - Timer Methods
    private func startTimer() {
        guard !timerRunning else { return } // prevent multiple timers
        timerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            elapsedTime += 0.01
            record.duration = elapsedTime
            updateCalories()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerRunning = false
        record.duration = elapsedTime
        record.date = Date() // update date automatically when stopping stopwatch
        
        // Switch to manual input and update the field
        useStopwatch = false
        manualDuration = formattedTime(elapsedTime)
        manualDate = Date() // reflect the new date in the date picker
        
        updateCalories()
    }

    
    // MARK: - Time Formatting
    private func formattedTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let milliseconds = Int((time.truncatingRemainder(dividingBy: 1)) * 1000)
        return String(format: "%02d:%02d.%03d", minutes, seconds, milliseconds)
    }
    
    private func parseManualDuration(_ text: String) -> TimeInterval {
        let parts = text.split(separator: ":")
        if parts.count == 2 {
            let minutes = Int(parts[0]) ?? 0
            let secParts = parts[1].split(separator: ".")
            let seconds = Int(secParts[0]) ?? 0
            let milliseconds = secParts.count > 1 ? Int(secParts[1].prefix(3)) ?? 0 : 0
            return TimeInterval(minutes * 60 + seconds) + TimeInterval(milliseconds) / 1000
        } else if parts.count == 1 {
            return TimeInterval(Int(parts[0]) ?? 0)
        } else {
            return 0
        }
    }
    
    // MARK: - Calories Calculation
    private func updateCalories() {
        let durationMinutes = record.duration / 60
        let caloriesPerMinute: Double
        switch record.intensity.lowercased() {
        case "low":
            caloriesPerMinute = 5
        case "medium":
            caloriesPerMinute = 8
        case "high":
            caloriesPerMinute = 12
        default:
            caloriesPerMinute = 0
        }
        record.calories = durationMinutes * caloriesPerMinute
    }
}
