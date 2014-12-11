//
//  Itinerary.h
//  ItineraryRequest
//
//  Created by Shao Chen on 12/10/14.
//  Copyright (c) 2014 Shao Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Itinerary : NSObject

@property (nonatomic) int day;
@property (strong, nonatomic) NSString * restaurant;
@property (strong, nonatomic) NSString * time;
@property (nonatomic) int order;

@end
