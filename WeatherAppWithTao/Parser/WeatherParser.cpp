//
//  WeatherParser.cpp
//  WeatherAppWithTao
//
//  Created by Alexey Kupriyanov on 15.02.2026.
//

#include <tao/json.hpp>
#include "WeatherParser.hpp"

using namespace tao::json;

static std::optional<double> getOptDouble(
    const value& value,
    const std::string& key
) {
    auto obj = value.get_object();
    auto it = obj.find(key);
    if (it == obj.end() || !it->second.is_double())
        return std::nullopt;

    return it->second.get_double();
}

static std::optional<unsigned int> getOptUnsigned(
    const value& value,
    const std::string& key
) {
    auto obj = value.get_object();
    auto it = obj.find(key);
    if (it == obj.end() || !it->second.is_unsigned())
        return std::nullopt;

    return it->second.get_unsigned();
}

struct CPPDayForecast {
    double dt;

    std::optional<double> temperature;
    std::optional<int> pressure;
    std::optional<int> humidity;
    std::optional<int> visibility;
    std::optional<int> clouds;
};

static std::vector<CPPDayForecast> parseForecast(const std::string& jsonStr)
{
    auto root = from_string(jsonStr);

    std::vector<CPPDayForecast> result;

    for (auto &day : root.at("list").get_array()) {
        CPPDayForecast item{};
        item.dt = day.at("dt").get_unsigned();
        item.temperature = getOptDouble(day.at("main"), "temp");
        item.pressure = getOptUnsigned(day.at("main"), "pressure");
        item.humidity = getOptUnsigned(day.at("main"), "humidity");
        item.clouds = getOptUnsigned(day.at("clouds"), "all");
        item.visibility = getOptUnsigned(day, "visibility");
        result.push_back(item);
    }

    return result;
}

double parseCurrentWeather(const char* json, int length) {
    auto root = from_string(std::string(json, length));
    return root.at("main").at("temp").get_double();
}

CDayForecast* parseForecast(const char* json, int length, int* count)
{
    auto days = parseForecast(std::string(json, length));

    *count = (int)days.size();

    auto* buffer = (CDayForecast*) malloc(sizeof(CDayForecast) * days.size());

    for (size_t i = 0; i < days.size(); ++i) {

        auto& src = days[i];
        auto& dst = buffer[i];

        dst.dt = src.dt;

        dst.hasTemperature = src.temperature.has_value();
        if (dst.hasTemperature)
            dst.temperature = *src.temperature;

        dst.hasPressure = src.pressure.has_value();
        if (dst.hasPressure)
            dst.pressure = *src.pressure;

        dst.hasHumidity = src.humidity.has_value();
        if (dst.hasHumidity)
            dst.humidity = *src.humidity;

        dst.hasVisibility = src.visibility.has_value();
        if (dst.hasVisibility)
            dst.visibility = *src.visibility;

        dst.hasClouds = src.clouds.has_value();
        if (dst.hasClouds)
            dst.clouds = *src.clouds;
    }

    return buffer;
}

void freeForecast(CDayForecast* ptr)
{
    free(ptr);
}
