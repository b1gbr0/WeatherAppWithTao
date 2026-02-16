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
        return data.withUnsafeBytes { raw in
            parseCurrentWeather(
                raw.bindMemory(to: CChar.self).baseAddress,
                Int32(data.count)
            )
        }
    }

    static func parseWeekly(from data: Data) throws -> [DayForecast] {
        var count: Int32 = 0

        let ptr = data.withUnsafeBytes { raw in
            parseForecast(
                raw.bindMemory(to: CChar.self).baseAddress,
                Int32(data.count),
                &count
            )
        }

        defer { freeForecast(ptr) }

        let buffer = UnsafeBufferPointer(
            start: ptr,
            count: Int(count)
        )

        return buffer.map { c in
            DayForecast(
                date: Date(timeIntervalSince1970: c.dt),
                temperature: c.hasTemperature ? c.temperature : nil,
                pressure: c.hasPressure ? Int(c.pressure) : nil,
                humidity: c.hasHumidity ? Int(c.humidity) : nil,
                visibility: c.hasVisibility ? Int(c.visibility) : nil,
                clouds: c.hasClouds ? Int(c.clouds) : nil
            )
        }
    }
}
