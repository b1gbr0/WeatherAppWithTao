//
//  WeatherParser.mm
//  WeatherAppWithTao
//
//  Created by Alexey Kupriyanov on 15.02.2026.
//

#include "WeatherParser.hpp"
#include <tao/json.hpp>

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

@implementation WeatherParser

+ (NSDictionary *)parseCurrentWeather:(NSData *)data {
    std::string jsonStr((const char *)data.bytes, data.length);
    auto root = from_string(jsonStr);
    double temp = root.at("main").at("temp").get_double();
    return @{
        @"temperature": @(temp)
    };
}

+ (NSArray<NSDictionary *> *)parseForecast:(NSData *)data {
    std::string jsonStr((const char*)data.bytes, data.length);
    auto root = from_string(jsonStr);

    NSMutableArray *result = [NSMutableArray array];

    for (auto &day : root.at("list").get_array()) {
        NSMutableDictionary *item = [NSMutableDictionary dictionary];

        item[@"dt"] = @(day.at("dt").get_unsigned());

        if (auto v = getOptDouble(day.at("main"), "temp"))
            item[@"temp"] = @(*v);

        if (auto v = getOptUnsigned(day.at("main"), "pressure"))
            item[@"pressure"] = @(*v);

        if (auto v = getOptUnsigned(day.at("main"), "humidity"))
            item[@"humidity"] = @(*v);

        if (auto v = getOptUnsigned(day.at("clouds"), "all"))
            item[@"clouds"] = @(*v);

        if (auto v = getOptUnsigned(day, "visibility"))
            item[@"visibility"] = @(*v);

        [result addObject:item];
    }

    return result;
}

@end
