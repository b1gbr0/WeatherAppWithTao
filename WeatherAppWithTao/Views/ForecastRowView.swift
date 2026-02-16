//
//  ForecastRowView.swift
//  WeatherAppWithTao
//
//  Created by Alexey Kupriyanov on 15.02.2026.
//

import SwiftUI

struct ForecastRowView: View {

    let model: ForecastRow

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            HStack {
                Text(model.dayText)
                    .font(.headline)

                Spacer()

                Text(model.temperatureText)
            }

            Text(model.pressureText)
            Text(model.humidityText)
            Text(model.visibilityText)
            Text(model.cloudsText)
        }
        .padding(.vertical, 6)
    }
}
