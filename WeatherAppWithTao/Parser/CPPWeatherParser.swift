//
//  CPPWeatherParser.swift
//  WeatherAppWithTao
//
//  Created by Alexey Kupriyanov on 15.02.2026.
//

import Foundation

enum ParserError: Error {
    case invalidFormat
}

struct CPPWeatherParser {
    static func parseCurrent(from data: Data) throws -> Double {
        guard
            let dict = WeatherParser.parseCurrentWeather(data) as? [String: Any],
            let temp = dict["temperature"] as? Double
        else {
            throw ParserError.invalidFormat
        }

        return temp
    }

    static func parseForecast(from data: Data) throws -> [DayForecast] {
        guard
            let dicts = WeatherParser.parseForecast(data) as? [[String: Any]]
        else {
            throw ParserError.invalidFormat
        }

        return try dicts.map {
            guard
                let dt = $0["dt"] as? Int
            else {
                throw ParserError.invalidFormat
            }
            return .init(
                date: Date(timeIntervalSince1970: Double(dt)),
                temperature: $0["temp"] as? Double,
                pressure: $0["pressure"] as? Int,
                humidity: $0["humidity"] as? Int,
                visibility: $0["visibility"] as? Int,
                clouds: $0["clouds"] as? Int
            )
        }
    }
}
