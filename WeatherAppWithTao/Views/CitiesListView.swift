//
//  CitiesListView.swift
//  WeatherAppWithTao
//
//  Created by Alexey Kupriyanov on 15.02.2026.
//

import SwiftUI

struct CitiesListView: View {
    @StateObject private var model = CityListViewModel(
        repository: WeatherRepositoryImpl(client: URLSessionClient())
    )

    var body: some View {
        NavigationStack {
            List {
                ForEach(City.allCases) { city in
                    NavigationLink {
                        CityDetailsView(
                            city: city,
                            repository: model.repository
                        )
                    } label: {
                        row(for: city)
                    }

                }
            }
            .navigationTitle("World Capitals")
        }
        .onAppear {
            model.loadAll()
        }
    }

    @ViewBuilder
    private func row(for city: City) -> some View {
        if let state = model.rows[city] {
            CityRowView(
                state: state,
                onRefresh: {
                    model.refresh(city)
                }
            )
        }
    }
}
