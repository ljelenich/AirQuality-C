//
//  DVMPollution.m
//  AirQuality ObjC
//
//  Created by LAURA JELENICH on 9/30/20.
//  Copyright © 2020 RYAN GREENBURG. All rights reserved.
//

#import "DVMPollution.h"

@implementation DVMPollution

- (instancetype)initWithInt:(NSInteger)aqi
{
    self = [super init];
    if (self)
    {
        _airQualityIndex = aqi;
    }
    return self;
}

@end

@implementation DVMPollution (JSONConvertable)

- (instancetype)initWithDictionary:(NSDictionary<NSString *,id> *)dictionary
{
    NSInteger aqi = [dictionary[@"aqius"] intValue];
    
    return [self initWithInt:aqi];
}

@end
