//
//  DVMCityAirQualityController.m
//  AirQuality ObjC
//
//  Created by LAURA JELENICH on 9/30/20.
//  Copyright © 2020 RYAN GREENBURG. All rights reserved.
//

#import "DVMCityAirQualityController.h"
#import "DVMCityAirQuality.h"

static NSString *const baseURLString = @"https://api.airvisual.com/";
static NSString *const version = @"v2";
static NSString *const countryComponent = @"countries";
static NSString *const stateComponenet = @"states";
static NSString *const cityComponent = @"cities";
static NSString *const cityDetailsComponent = @"city";
static NSString *const apiKey = @"303a93f9-79c6-42e3-8346-be1b24964498";

@implementation DVMCityAirQualityController

+ (void)fetchSupportedCountries:(void (^)(NSArray<NSString *> * _Nonnull))completion
{
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSURL *versionURL = [baseURL URLByAppendingPathComponent:version];
    NSURL *countryURL = [versionURL URLByAppendingPathComponent:countryComponent];
    
    NSMutableArray<NSURLQueryItem *> *queryItem = [NSMutableArray new];
    NSURLQueryItem *apiKeyQuery = [[NSURLQueryItem alloc] initWithName:@"key" value:apiKey];
    [queryItem addObject:apiKeyQuery];
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithURL:countryURL resolvingAgainstBaseURL:true];
    [urlComponents setQueryItems:queryItem];
    
    NSURL *finalURL = [urlComponents URL];
    NSLog(@"%@", finalURL);
    
    [[NSURLSession.sharedSession dataTaskWithURL:finalURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error)
        {
            NSLog(@"There was an error: %@", error);
            completion(nil);
            return;
        }
        
        if (!data)
        {
            NSLog(@"Error there appears to be no data: %@", error);
            completion(nil);
            return;
        }
        
        NSDictionary *topLevelDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        NSDictionary *dataDictionary = topLevelDictionary[@"data"];
        NSMutableArray *countries = [NSMutableArray new];
        for (NSDictionary *countryDictionary in dataDictionary)
        {
            NSString *country = [[NSString alloc] initWithString:countryDictionary[@"country"]];
            [countries addObject:country];
        }
        completion(countries);
        
    }] resume];
}

+ (void)fetchSupportedStatesInCountry:(NSString *)country completion:(void (^)(NSArray<NSString *> * _Nonnull))completion
{
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSURL *versionURL = [baseURL URLByAppendingPathComponent:version];
    NSURL *stateURL = [versionURL URLByAppendingPathComponent:stateComponenet];
    
    NSMutableArray<NSURLQueryItem *> *queryItem = [NSMutableArray new];
    
    NSURLQueryItem *countryQuery = [[NSURLQueryItem alloc] initWithName:@"country" value:country];
    NSURLQueryItem *apiKeyQuery = [[NSURLQueryItem alloc] initWithName:@"key" value:apiKey];
    [queryItem addObject:countryQuery];
    [queryItem addObject:apiKeyQuery];
    
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithURL:stateURL resolvingAgainstBaseURL:true];
    [urlComponents setQueryItems:queryItem];
    NSURL *finalURL = [urlComponents URL];
    
    [[NSURLSession.sharedSession dataTaskWithURL:finalURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error)
        {
            NSLog(@"There was an error: %@", error);
            completion(nil);
            return;
        }
        
        if (!data)
        {
            NSLog(@"Error there appears to be no data: %@", error);
            completion(nil);
            return;
        }
        
        NSDictionary *topLevelDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSDictionary *dataDictionary = topLevelDictionary[@"data"];
        NSMutableArray *states = [NSMutableArray new];
        for (NSDictionary *stateDictionary in dataDictionary)
        {
            NSString *state = stateDictionary[@"state"];
            [states addObject:state];
        }
        completion(states);
        
    }] resume];
}

+ (void)fetchSupportedCitiesInState:(NSString *)state country:(NSString *)coutry completion:(void (^)(NSArray<NSString *> * _Nonnull))completion
{
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSURL *versionURL = [baseURL URLByAppendingPathComponent:version];
    NSURL *citiesURL = [versionURL URLByAppendingPathComponent:cityComponent];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray new];
    
    NSURLQueryItem *stateQuery = [[NSURLQueryItem alloc] initWithName:@"state" value:state];
    NSURLQueryItem *countryQuery = [[NSURLQueryItem alloc] initWithName:@"country" value:coutry];
    NSURLQueryItem *apiKeyQuery = [[NSURLQueryItem alloc] initWithName:@"key" value:apiKey];
    
    [queryItems addObject:stateQuery];
    [queryItems addObject:countryQuery];
    [queryItems addObject:apiKeyQuery];
    
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithURL:citiesURL resolvingAgainstBaseURL:true];
    
    [urlComponents setQueryItems:queryItems];
    
    NSURL *finalURL = [urlComponents URL];
    
    [[NSURLSession.sharedSession dataTaskWithURL:finalURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error)
        {
            NSLog(@"There was an error: %@", error);
            completion(nil);
            return;
        }
        
        if (!data)
        {
            NSLog(@"Error there appears to be no data: %@", error);
            completion(nil);
            return;
        }
        
        NSDictionary *topLevelDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSDictionary *dataDictionary = topLevelDictionary[@"data"];
        NSMutableArray *cities = [NSMutableArray new];
        for (NSDictionary *cityDictionary in dataDictionary)
        {
            NSString *city = cityDictionary[@"city"];
            [cities addObject:city];
        }
        completion(cities);
        
    }] resume];
}

+ (void)fetchDataForCity:(NSString *)city state:(NSString *)state country:(NSString *)country completion:(void (^)(DVMCityAirQuality * _Nonnull))completion
{
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSURL *versionURL = [baseURL URLByAppendingPathComponent:version];
    NSURL *cityURL = [versionURL URLByAppendingPathComponent:cityDetailsComponent];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray new];
    
    NSURLQueryItem *cityQuery = [[NSURLQueryItem alloc] initWithName:@"city" value:city];
    NSURLQueryItem *stateQuery = [[NSURLQueryItem alloc] initWithName:@"state" value:state];
    NSURLQueryItem *countryQuery = [[NSURLQueryItem alloc] initWithName:@"country" value:country];
    NSURLQueryItem *apiKeyQuery = [[NSURLQueryItem alloc] initWithName:@"key" value:apiKey];
    
    [queryItems addObject:cityQuery];
    [queryItems addObject:stateQuery];
    [queryItems addObject:countryQuery];
    [queryItems addObject:apiKeyQuery];
    
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithURL:cityURL resolvingAgainstBaseURL:true];
    
    [urlComponents setQueryItems:queryItems];
    
    NSURL *finalURL = [urlComponents URL];
    
    [[NSURLSession.sharedSession dataTaskWithURL:finalURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error)
        {
            NSLog(@"There was an error: %@", error);
            completion(nil);
            return;
        }
        
        if (!data)
        {
            NSLog(@"Error there appears to be no data: %@", error);
            completion(nil);
            return;
        }
        
        NSDictionary *topLevel = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSDictionary *dataDict = topLevel[@"data"];
        
        DVMCityAirQuality *cityAQI = [[DVMCityAirQuality alloc] initWithDictionary:dataDict];
        completion(cityAQI);
    }] resume];
}
@end
