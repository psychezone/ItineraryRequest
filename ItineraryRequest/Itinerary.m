//
//  Itinerary.m
//  ItineraryRequest
//
//  Created by Shao Chen on 12/10/14.
//  Copyright (c) 2014 Shao Chen. All rights reserved.
//

#import "Itinerary.h"

@implementation Itinerary

@synthesize day = _day;
@synthesize restaurant = _restaurant;
@synthesize time = _time;
@synthesize order = _order;


- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeInt:self.day forKey:@"day"];
    [encoder encodeObject:self.restaurant forKey:@"restaurant"];
    [encoder encodeObject:self.time forKey:@"time"];
    [encoder encodeInt:self.order forKey:@"order"];

}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.day = [decoder decodeIntForKey:@"day"];
        self.restaurant = [decoder decodeObjectForKey:@"name"];
        self.time = [decoder decodeObjectForKey:@"time"];
        self.order = [decoder decodeIntForKey:@"order"];
       
    }
    return self;
}


@end
