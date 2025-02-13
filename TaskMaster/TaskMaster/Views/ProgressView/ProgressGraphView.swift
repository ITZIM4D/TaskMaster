//
//  ProgressGraphView.swift
//  TaskMaster
//
//  Created by Jared Wilson on 1/14/25.
//

import SwiftUI

import SwiftUI
import Charts

// Model to hold daily task data
struct DailyTaskData: Identifiable {
    let id = UUID()
    let date: Date
    let completedCount: Int
}

struct ProgressGraphView: View {
    let networkingManager = NetworkingManager()
    @StateObject private var appState = AppState.shared
    @State private var dailyTaskData: [DailyTaskData] = []
    
    var body: some View {
        VStack {
            // Task completion graph
            VStack(alignment: .leading) {
                Text("Tasks Completed Per Day")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading)
                
                Chart(dailyTaskData) { dayData in
                    BarMark(
                        x: .value("Date", dayData.date),
                        y: .value("Completed Tasks", dayData.completedCount),
                        width: 40
                        
                    )
                    .offset(x: 20)
                    .foregroundStyle(Color.green.gradient)
                }
                .frame(height: 300)
                .padding()
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { value in
                        AxisGridLine()
                        AxisValueLabel {
                            // Changed from .day() to .month().day() to show both month and day
                            if let date = value.as(Date.self) {
                                Text(date, format: .dateTime.month().day())
                            }
                        }
                    }
                }
                .chartXScale(domain: Calendar.current.date(byAdding: .day, value: -5, to: Date())!...Date())
                .chartYAxis {
                    AxisMarks() {
                        AxisValueLabel()
                            .offset(x: 10)
                    }
                }
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
            .padding()
            
            Spacer()
        }
        .onAppear {
            loadData()
        }
    }
    
    private func loadData() {
        let url = "http://localhost:8080/api/tasks"
        
        networkingManager.getRequest(url: url) { response in
            DispatchQueue.main.async {
                guard let tasksData = response as? [[String: Any]] else {
                    print("Failed to parse tasks data")
                    return
                }
                
                var tasksByDate: [Date: Int] = [:]
                
                
                for task in tasksData {
                    if let user = task["user"] as? [String: Any], let userID = user["userID"] as? Int {
                        if userID == appState.currentUserID {
                            // Check if completedAt exists and isn't nil
                            if let completedAtString = task["completedAt"] as? String {
                                // Parse the ISO 8601 date string
                                let formatter = ISO8601DateFormatter()
                                formatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
                                
                                if let completedAt = formatter.date(from: completedAtString) {
                                    let calendar = Calendar.current
                                    let dateOnly = calendar.startOfDay(for: completedAt)
                                    tasksByDate[dateOnly, default: 0] += 1
                                }
                            }
                        }
                    }
                }
                
                // Convert dictionary to array of DailyTaskData
                self.dailyTaskData = tasksByDate.map { DailyTaskData(date: $0.key, completedCount: $0.value) }
                    .sorted { $0.date < $1.date }
            }
        }
    }
}

struct ProgressGraphView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressGraphView()
    }
}

