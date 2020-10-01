//
//  DVMCityAirQuality.m
//  AirQuality ObjC
//
//  Created by LAURA JELENICH on 9/30/20.
//  Copyright © 2020 RYAN GREENBURG. All rights reserved.
//

#import "DVMCityAirQuality.h"
#import "DVMWeather.h"
#import "DVMPollution.h"

@implementation DVMCityAirQuality

- (instancetype)initWithCity:(NSString *)city state:(NSString *)state country:(NSString *)country weather:(DVMWeather *)weather polluton:(DVMWeather *)pollution
{
    self = [super init];
    if (self)
    {
        _city = city;
        _state = state;
        _country = country;
        _weather = weather;
        _pollution = pollution;
    }
    return self;
}

@end

@implementation DVMCityAirQuality (JSONConvertable)

- (instancetype)initWithDictionary:(NSDictionary<NSString *,id> *)dictionary
{
    NSString *city = dictionary[@"city"];
    NSString *state = dictionary[@"state"];
    NSString *country = dictionary[@"country"];
    
    NSDictionary *current = dictionary[@"current"];
    DVMWeather *weather = [[DVMWeather alloc] initWithDictionary:current[@"weather"]];
    DVMPollution *pollution = [[DVMPollution alloc] initWithDictionary:current[@"pollution"]];
    
    return [self initWithCity:city state:state country:country weather:weather polluton:pollution];
}

@end
