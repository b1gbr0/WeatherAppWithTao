//
//  CityListViewModel.swift
//  WeatherAppWithTao
//
//  Created by Alexey Kupriyanov on 15.02.2026.
//

import SwiftUI
import Combine

enum CityWeatherRowState {
    case loading
    case loaded(CityWeatherRow)
    case error(String)
}

struct CityWeatherRow: Identifiable {
    let id: City
    let title: String
    let temperatureText: String
    let isCold: Bool
}

final class CityListViewModel: ObservableObject {

    @Published private(set) var rows: [City: CityWeatherRowState] = [:]

    let repository: WeatherRepository

        init(repository: WeatherRepository) {
            self.repository = repository

            City.allCases.forEach {
                rows[$0] = .loading
            }
        }

    func refresh(_ city: City) {
        rows[city] = .loading

        Task {
            do {
                let weather = try await repository.weather(for: city)
                updateRow(city: city, result: .success(weather))
            } catch {
                updateRow(city: city, result: .failure(error))
            }
        }
    }

    func loadAll() {
        Task {
            await loadAllInternal()
        }
    }

    private func loadAllInternal() async {

        await withTaskGroup(of: (City, Result<CityWeather, Error>).self) { group in

            for city in City.allCases {
                group.addTask { [repository] in
                    do {
                        let weather = try await repository.weather(for: city)
                        return (city, .success(weather))
                    } catch {
                        return (city, .failure(error))
                    }
                }
            }

            for await (city, result) in group {
                updateRow(city: city, result: result)
            }
        }
    }

    private func updateRow(city: City, result: Result<CityWeather, Error>) {

        switch result {
        case .success(let weather):
            rows[city] = .loaded(
                CityWeatherRow(
                    id: city,
                    title: city.name,
                    temperatureText: "\(Int(weather.temperature))°",
                    isCold: weather.temperature < 10
                )
            )

        case .failure:
            rows[city] = .error("Failed to load")
        }
    }
}
