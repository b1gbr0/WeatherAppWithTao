//
//  AppConfig.swift
//  WeatherAppWithTao
//
//  Created by Alexey Kupriyanov on 15.02.2026.
//

enum AppConfig {
    static var apiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "OPEN_WEATHER_API_KEY") as? String
        else {
            fatalError("API key missing")
        }
        return key
    }
}
