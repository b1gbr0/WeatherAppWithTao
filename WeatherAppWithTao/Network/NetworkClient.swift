//
//  NetworkClient.swift
//  WeatherAppWithTao
//
//  Created by Alexey Kupriyanov on 15.02.2026.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
}

protocol NetworkClient {
    func request(url: URL) async throws -> Data
}

final class URLSessionClient: NetworkClient {
    func request(url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }

        return data
    }
}
