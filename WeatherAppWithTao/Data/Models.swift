//
//  Models.swift
//  WeatherAppWithTao
//
//  Created by Alexey Kupriyanov on 15.02.2026.
//

enum City: String, CaseIterable, Identifiable {
    case london
    case paris
    case newYork
    case rome
    case moscow

    var id: String { rawValue }

    var name: String {
        switch self {
        case .london: return "London"
        case .paris: return "Paris"
        case .newYork: return "New York"
        case .rome: return "Rome"
        case .moscow: return "Moscow"
        }
    }
}

struct WeeklyForecast {
    let city: City
    let days: [DayForecast]
}

struct DayForecast: Identifiable {
    let id = UUID()
    let date: Date
    let temperature: Double?
    let pressure: Int?
    let humidity: Int?
    let visibility: Int?
    let clouds: Int?
}
