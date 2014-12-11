//
//  CCUIDatePicker.h
//  ItineraryRequest
//
//  Created by Shao Chen on 12/10/14.
//  Copyright (c) 2014 Shao Chen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CCUIDatePicker : UIDatePicker

@property (nonatomic, weak) UIButton *button;
@property (nonatomic) NSInteger section;
@property (nonatomic) NSInteger row;

@end
