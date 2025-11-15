//
//  AddFitnessRecordFormView.swift
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
    @State private var manualDuration: String = "00:00.000"
    @State private var manualDate: Date = Date()

    @State private var showErrorAlert = false

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
            .onChange(of: record.intensity) { _ in updateCalories() }

            // Manual vs Stopwatch toggle
            Picker("Time Input", selection: $useStopwatch) {
                Text("Manual").tag(false)
                Text("Stopwatch").tag(true)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            // Duration Input Section
            VStack(spacing: 20) {
                if useStopwatch {

                    Text(formattedTime(elapsedTime))
                        .font(.system(size: 32, weight: .bold, design: .monospaced))
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)

                    HStack(spacing: 40) {
                        if !timerRunning {
                            Button("Start", action: startTimer)
                                .bold()
                                .frame(width: 100, height: 50)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        if timerRunning {
                            Button("Stop", action: stopTimer)
                                .bold()
                                .frame(width: 100, height: 50)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }

                } else {
                    VStack(spacing: 10) {
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

                        DatePicker("Date", selection: $manualDate,
                                   displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact)
                            .padding(.horizontal, 60)
                            .onChange(of: manualDate) { newDate in
                                record.date = newDate
                            }
                    }
                    .frame(maxWidth: .infinity)
                }
            }

            // Estimated Calories
            Text("Estimated Calories: \(Int(record.calories)) kcal")
                .font(.title2)
                .bold()

            // Save Button
            Button {
                viewModel.save(record: record)

                if viewModel.saveError == nil {
                    presentationMode.wrappedValue.dismiss()
                } else {
                    showErrorAlert = true
                }

            } label: {
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
        .onDisappear { stopTimer() }
        .padding(.top, 20)
        .alert("Save Failed",
               isPresented: $showErrorAlert,
               actions: { Button("OK", role: .cancel) {} },
               message: { Text(viewModel.saveError?.localizedDescription ?? "Unknown error") })
    }

    // Timer
    private func startTimer() {
        guard !timerRunning else { return }
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
        record.date = Date()

        useStopwatch = false
        manualDuration = formattedTime(elapsedTime)
        manualDate = Date()

        updateCalories()
    }

    // Formatting
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
        }
        return 0
    }

    private func updateCalories() {
        let durationMinutes = record.duration / 60
        let caloriesPerMinute: Double =
            record.intensity.lowercased() == "low" ? 5 :
            record.intensity.lowercased() == "medium" ? 8 :
            record.intensity.lowercased() == "high" ? 12 : 0

        record.calories = durationMinutes * caloriesPerMinute
    }
    
}
