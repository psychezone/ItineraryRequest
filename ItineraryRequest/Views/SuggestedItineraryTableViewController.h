//
//  SuggestedItineraryTableViewController.h
//  ItineraryRequest
//
//  Created by Shao Chen on 12/10/14.
//  Copyright (c) 2014 Shao Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYPopoverController.h"
#import "CCUIDatePicker.h"

@interface SuggestedItineraryTableViewController : UITableViewController<WYPopoverControllerDelegate>

@property (strong, nonatomic) NSMutableArray *itineraries;
@property (strong, nonatomic) NSMutableArray *days;
@property (strong, nonatomic) NSMutableArray *selectedItineraries;
@property int numDays;
@property (strong, nonatomic) CCUIDatePicker *datepicker;
@property (strong, nonatomic) WYPopoverController *popOverForDatePicker;

- (IBAction)onClickCheckmark:(UIButton *)sender;
- (IBAction)onSelectAllPressed:(UIBarButtonItem *)sender;
- (IBAction)onTimeButtonPressed:(UIButton *)sender;

@end
