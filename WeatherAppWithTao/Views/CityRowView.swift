//
//  CityRowView.swift
//  WeatherAppWithTao
//
//  Created by Alexey Kupriyanov on 15.02.2026.
//

import SwiftUI

struct CityRowView: View {

    let state: CityWeatherRowState
    let onRefresh: () -> Void

    var body: some View {
        switch state {

        case .loading:
            ProgressView()

        case .error(let message):
            HStack {
                Text(message)
                Spacer()
                Button("Retry", action: {})
                    .onTapGesture {
                        onRefresh()
                    }
//                    .buttonStyle(.borderless)
            }

        case .loaded(let model):
            HStack {
                Text(model.title)

                Spacer()

                Text(model.temperatureText)

                Button(action: {}) {
                    Image(systemName: "arrow.clockwise")
                }
                .onTapGesture {
                    onRefresh()
                }
//                .buttonStyle(.borderless)
            }
            .padding(8)
            .background(
                model.isCold
                ? Color.blue.opacity(0.2)
                : Color.clear
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}
