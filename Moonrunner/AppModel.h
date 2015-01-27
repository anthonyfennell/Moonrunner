//
//  AppModel.h
//  Moonrunner
//
//  Created by Anthony Fennell on 1/26/15.
//  Copyright (c) 2015 Anthony Fennell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Run.h"
#import "Location.h"

@interface AppModel : NSObject

+ (instancetype)sharedModel;

- (Run *)saveRunDistance:(float)distance duration:(int)duration locations:(NSArray *)locations;

- (NSString *)stringifyDistance:(double)meters;
- (NSString *)stringifySecondCount:(int)seconds usingLongFormat:(BOOL)longFormat;
- (NSString *)stringifyAvgPaceFromDist:(double)meters overTime:(int)seconds driving:(BOOL)isDrive;

- (NSArray *)colorSegmentsForLocations:(NSArray *)locations;

@end
