//
//  CityDetailsView.swift
//  WeatherAppWithTao
//
//  Created by Alexey Kupriyanov on 15.02.2026.
//

import SwiftUI

struct CityDetailsView: View {

    @StateObject private var model: CityDetailsViewModel

    init(city: City, repository: WeatherRepository) {
        _model = StateObject(
            wrappedValue: CityDetailsViewModel(
                city: city,
                repository: repository
            )
        )
    }

    var body: some View {
        content
            .navigationTitle(model.city.name)
            .onAppear { model.load() }
    }

    @ViewBuilder
    private var content: some View {

        switch model.state {

        case .loading:
            ProgressView()

        case .error(let message):
            VStack {
                Text(message)
                Button("Retry") {
                    model.load()
                }
            }

        case .loaded(let rows):
            List(rows) { row in
                ForecastRowView(model: row)
            }
        }
    }

}
