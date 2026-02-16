//
//  WeatherParser.hpp
//  WeatherAppWithTao
//
//  Created by Alexey Kupriyanov on 15.02.2026.
//

#import <Foundation/Foundation.h>

@interface WeatherParser : NSObject

+(NSDictionary*)parseCurrentWeather: (NSData *)data;
+(NSArray<NSDictionary*> *)parseForecast: (NSData *)data;

@end
