//
//  PListBO.m
//  ItineraryRequest
//
//  Created by Shao Chen on 12/10/14.
//  Copyright (c) 2014 Shao Chen. All rights reserved.
//

#import "PListBO.h"

@implementation PListBO

+(NSMutableArray *)getPListFromResource:(NSString *)pListName{

    NSMutableArray *objects;
    NSString *itemsPath = [[NSBundle mainBundle] pathForResource:pListName ofType:@"plist"];
    
    objects = [[NSMutableArray alloc] initWithContentsOfFile:itemsPath];
    
    return objects;
}

@end
