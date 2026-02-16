//
//  CityDetailsViewModel.swift
//  WeatherAppWithTao
//
//  Created by Alexey Kupriyanov on 15.02.2026.
//

import SwiftUI
import Combine

enum ForecastRowState {
    case loading
    case loaded([ForecastRow])
    case error(String)
}

struct ForecastRow: Identifiable {
    let id: UUID
    let dayText: String
    let temperatureText: String
    let pressureText: String
    let humidityText: String
    let visibilityText: String
    let cloudsText: String
}

final class CityDetailsViewModel: ObservableObject {
    @Published private(set) var state: ForecastRowState = .loading

    let city: City
    private let repository: WeatherRepository

    init(
        city: City,
        repository: WeatherRepository
    ) {
        self.city = city
        self.repository = repository
    }

    func load() {
        Task {
            await loadInternal()
        }
    }

    private func loadInternal() async {

        state = .loading

        do {
            let forecast = try await repository.weeklyForecast(for: city)

            let uiModels = forecast.days.map(mapToUI)

            state = .loaded(uiModels)

        } catch {
            state = .error("Failed to load forecast")
        }
    }

    private func mapToUI(_ day: DayForecast) -> ForecastRow {

        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, hh:mm"

        return ForecastRow(
            id: day.id,
            dayText: formatter.string(from: day.date),
            temperatureText: day.temperature.map { "\($0)°" } ?? "—",
            pressureText: "Pressure: \(day.pressure, default: "-")",
            humidityText: "Humidity: " + (day.humidity.map { "\($0)%" } ?? "-"),
            visibilityText: "Visibility: " + (day.visibility.map { "\($0)m" } ?? "-"),
            cloudsText: "Clouds: " + (day.clouds.map { "\($0)%" } ?? "-")
        )
    }
}
