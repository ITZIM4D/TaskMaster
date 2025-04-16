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
    @State private var selectedTimeframe: Timeframe = .month
    
    enum Timeframe: String, CaseIterable, Identifiable {
        case week = "Week"
        case month = "Month"
        case quarter = "3 Months"
        case year = "Year"
        
        var id: String { self.rawValue }
        
        var daysToShow: Int {
            switch self {
            case .week: return 7
            case .month: return 30
            case .quarter: return 90
            case .year: return 365
            }
        }
    }
    
    var body: some View {
        VStack {
            Picker("Timeframe", selection: $selectedTimeframe) {
                ForEach(Timeframe.allCases) { timeframe in
                    Text(timeframe.rawValue).tag(timeframe)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            VStack(alignment: .leading) {
                Text("Tasks Completed Per Day")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading)
                Chart(dailyTaskData.filter {
                    $0.date >= Calendar.current.date(byAdding: .day, value: -selectedTimeframe.daysToShow, to: Date())!
                }) { dayData in
                    BarMark(
                        x: .value("Date", dayData.date),
                        y: .value("Completed Tasks", dayData.completedCount),
                        width: MarkDimension(floatLiteral: calculateBarWidth())
                    )
                    .foregroundStyle(Color.green.gradient)
                    
                }
                .frame(height: 300)
                .padding()
                .chartXAxis {
                    AxisMarks(values: .stride(by: strideInterval())) { value in
                        AxisGridLine()
                        AxisValueLabel {
                            if let date = value.as(Date.self) {
                                if shouldShowLabel(for: date) {
                                    Text(date, format: dateFormat())
                                }
                            }
                        }
                    }
                }
                .chartXScale(domain: Calendar.current.date(byAdding: .day, value: -selectedTimeframe.daysToShow, to: Date())!...Date())
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
            
            HStack(spacing: 20) {
                StatisticView(title: "Total", value: totalTasksCompleted)
                StatisticView(title: "Average", value: String(format: "%.1f", averageTasksPerDay))
            }
            .padding()
            
            Spacer()
        }
        .onAppear {
            loadData()
        }
    }
    
    private func calculateBarWidth() -> CGFloat {
        switch selectedTimeframe {
        case .week: return 30
        case .month: return 12
        case .quarter: return 6
        case .year: return 2
        }
    }
    
    private func strideInterval() -> Calendar.Component {
        switch selectedTimeframe {
        case .week: return .day
        case .month: return .day
        case .quarter: return .weekOfYear
        case .year: return .month
        }
    }
    
    private func dateFormat() -> Date.FormatStyle {
        switch selectedTimeframe {
        case .week:
            return .dateTime.month().day()
        case .month:
            return .dateTime.month().day()
        case .quarter, .year:
            return .dateTime.month()
        }
    }
    
    private func shouldShowLabel(for date: Date) -> Bool {
        let calendar = Calendar.current
        
        switch selectedTimeframe {
        case .week:
            // Show all days in a week
            return true
        case .month:
            // Show only every 7 days (weekly)
            return calendar.component(.day, from: date) % 7 == 1
        case .quarter:
            // Show only the 1st of each month
            return calendar.component(.day, from: date) == 1
        case .year:
            // Show only every other month
            return calendar.component(.day, from: date) == 1 &&
                   calendar.component(.month, from: date) % 2 == 1
        }
    }
    
    private var dateRangeText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -selectedTimeframe.daysToShow, to: endDate)!
        
        return "Showing data from \(formatter.string(from: startDate)) to \(formatter.string(from: endDate))"
    }
    
    private var filteredData: [DailyTaskData] {
        dailyTaskData.filter {
            $0.date >= Calendar.current.date(byAdding: .day, value: -selectedTimeframe.daysToShow, to: Date())!
        }
    }
    
    private var totalTasksCompleted: String {
        let total = filteredData.reduce(0) { $0 + $1.completedCount }
        return "\(total)"
    }
    
    private var averageTasksPerDay: Double {
        let total = filteredData.reduce(0) { $0 + $1.completedCount }
        return filteredData.isEmpty ? 0 : Double(total) / Double(filteredData.count)
    }
    
    private var bestDayCount: Int {
        filteredData.max(by: { $0.completedCount < $1.completedCount })?.completedCount ?? 0
    }
    
    private func loadData() {
        let userID = appState.currentUserID!
        let url = "http://localhost:8080/api/tasks/user/\(String(userID))"
        
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

struct StatisticView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 1)
    }
}

struct ProgressGraphView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressGraphView()
    }
}

