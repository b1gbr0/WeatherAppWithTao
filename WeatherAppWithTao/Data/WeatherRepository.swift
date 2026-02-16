//
//  WeatherRepository.swift
//  WeatherAppWithTao
//
//  Created by Alexey Kupriyanov on 15.02.2026.
//

protocol WeatherRepository {
    func weather(for city: City) async throws -> CityWeather
    func weeklyForecast(for: City) async throws -> WeeklyForecast
}

struct CityWeather {
    let city: City
    let temperature: Double
}

final class WeatherRepositoryImpl: WeatherRepository {

    private let client: NetworkClient

    init(client: NetworkClient) {
        self.client = client
    }

    func weather(for city: City) async throws -> CityWeather {

        let data = try await client.request(url: buildURL(for: city, with: "weather"))

        let temperature = try CPPWeatherParser.parseCurrent(from: data)

        return CityWeather(
            city: city,
            temperature: temperature
        )
    }

    func weeklyForecast(for city: City) async throws -> WeeklyForecast {
        let data = try await client.request(url: buildURL(for: city, with: "forecast"))

        let days = try CPPWeatherParser.parseForecast(from: data)

        return WeeklyForecast(city: city, days: days)
    }
}

extension WeatherRepositoryImpl {
    private func buildURL(for city: City, with path: String) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/\(path)"

        components.queryItems = [
            .init(name: "q", value: "\(city.name)"),
            .init(name: "appid", value: AppConfig.apiKey),
            .init(name: "units", value: "metric")
        ]

        return components.url!
    }
}

