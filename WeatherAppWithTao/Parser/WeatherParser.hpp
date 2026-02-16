//
//  WeatherParser.hpp
//  WeatherAppWithTao
//
//  Created by Alexey Kupriyanov on 15.02.2026.
//

#include <stdbool.h>

#pragma once

#ifdef __cplusplus
extern "C" {
#endif

typedef struct CDayForecast {
    double dt;

    bool hasTemperature;
    double temperature;

    bool hasPressure;
    int pressure;

    bool hasHumidity;
    int humidity;

    bool hasVisibility;
    int visibility;

    bool hasClouds;
    int clouds;
} CDayForecast;

double parseCurrentWeather(const char* json, int length);
CDayForecast* parseForecast(const char* json, int length, int* count);
void freeForecast(CDayForecast* ptr);

#ifdef __cplusplus
}
#endif
