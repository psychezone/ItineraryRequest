//
//  SuggestedItineraryTableViewController.m
//  ItineraryRequest
//
//  Created by Shao Chen on 12/10/14.
//  Copyright (c) 2014 Shao Chen. All rights reserved.
//

#import "SuggestedItineraryTableViewController.h"
#import "PListBO.h"
#import "Itinerary.h"

@interface SuggestedItineraryTableViewController ()

@end

@implementation SuggestedItineraryTableViewController

@synthesize itineraries = _itineraries;
@synthesize selectedItineraries = _selectedItineraries;
@synthesize days = _days;
@synthesize numDays = _numDays;
@synthesize datepicker = _datepicker;
@synthesize popOverForDatePicker = _popOverForDatePicker;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.itineraries = [[NSMutableArray alloc] init];
    self.numDays = 0;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //get list of itinerary
    self.itineraries = [PListBO getPListFromResource:@"itinerary"];
    self.numDays = (int)[self getNumberOfDays];
    self.days = [[NSMutableArray alloc] initWithCapacity:self.numDays];
    
    self.selectedItineraries = [[NSMutableArray alloc] init];
    
    [self addTableFooter];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    //Return the number of sections.
    return self.numDays;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [self getNumberOfItemsPerDay:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(self.itineraries.count > 0){
        return [NSString stringWithFormat:@"Day %d", (int)section + 1];
    }else{
        return @"";
    }
}

//resize cell height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"restaurantRow" forIndexPath:indexPath];
    
    //configure cell content
    
    Itinerary *itinerary = [self getItineraryForRow:indexPath.section row:indexPath.row];
    
    //set checkmark
    UIButton *checkmark = (UIButton *)[cell viewWithTag:3];
    [checkmark setImage:[UIImage imageNamed:@"checkmark.png"] forState:UIControlStateNormal];
    [checkmark setImage:[UIImage imageNamed:@"checkmark.png"] forState:UIControlStateDisabled];
    [checkmark setImage:[UIImage imageNamed:@"checkmark_on.png"] forState:UIControlStateSelected];
    [checkmark setImage:[UIImage imageNamed:@"checkmark_on.png"] forState:UIControlStateHighlighted];
    
    //set restaurant name
    UILabel *restaurantName = (UILabel*) [cell viewWithTag:1];
    [restaurantName setText:itinerary.restaurant];

    //set time
    UIButton *time = (UIButton *) [cell viewWithTag:2];
    [time setTitle:itinerary.time forState:UIControlStateNormal];
    
    return cell;
}



#pragma mark - helpers
-(NSInteger)getNumberOfDays{
    
    NSArray *uniqueDays = [self.itineraries valueForKeyPath:@"@distinctUnionOfObjects.day"];
    return uniqueDays.count;
}


-(NSInteger)getNumberOfItemsPerDay:(NSInteger)section{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day == %d", (int)section + 1];
    NSArray *items = [self.itineraries filteredArrayUsingPredicate:predicate];
    return items.count;

}

-(Itinerary *)getItineraryForRow:(NSInteger)section row:(NSInteger)row{
    
    Itinerary *itinerary = [[Itinerary alloc] init];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day == %d AND order == %d", (int)section + 1, (int)row];
    NSArray *items = [self.itineraries filteredArrayUsingPredicate:predicate];
    itinerary.restaurant = [[items objectAtIndex:0] objectForKey:@"restaurant"];
    itinerary.time = [[items objectAtIndex:0] objectForKey:@"time"];
    
    return itinerary;
}

-(void) addTableFooter{
    //add itinerary button to footer
    
    UIImage *button = [[UIImage imageNamed:@"button_green.png"]
                       resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    UIImage *buttonImageSelected = [[UIImage imageNamed:@"button_down_green.png"]
                                    resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addButton setFrame:CGRectMake(0, 0, 250, 44)];
    [addButton setBackgroundImage:button forState:UIControlStateNormal];
    [addButton setBackgroundImage:buttonImageSelected forState:UIControlStateHighlighted];
    [addButton setTitle:@"Add to My Itinerary" forState:UIControlStateNormal];
    [addButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect footerViewRect = CGRectMake(0, 0, 300, 44);
    UIView *buttonView = [[UIView alloc]initWithFrame:footerViewRect];
    [buttonView addSubview:addButton];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(70, 350, 300, 50)];
    [self.tableView.tableFooterView addSubview:buttonView];

}

- (BOOL)hasItinerary:(Itinerary *)itinerary{
    for(int i = 0; i < self.selectedItineraries.count; i++){
        Itinerary *selectedItinerary = [self.selectedItineraries objectAtIndex:i];
        if([selectedItinerary.restaurant isEqualToString:itinerary.restaurant]){
            return YES;
        }
    }
    return NO;
}

- (void)removeItinerary:(Itinerary *)itinerary{
    
    for(int i = 0; i < self.selectedItineraries.count; i++){
        Itinerary *selectedItinerary = [self.selectedItineraries objectAtIndex:i];
        if([selectedItinerary.restaurant isEqualToString:itinerary.restaurant]){
            [self.selectedItineraries removeObjectAtIndex:i];
        }
    }
    
}
-(void)updateItineraryTime:(Itinerary *)itinerary{
    for(int i = 0; i < self.selectedItineraries.count; i++){
        Itinerary *selectedItinerary = [self.selectedItineraries objectAtIndex:i];
        if([selectedItinerary.restaurant isEqualToString:itinerary.restaurant]){
            selectedItinerary.time = itinerary.time;
            [self.selectedItineraries replaceObjectAtIndex:i withObject:selectedItinerary];
        }
    }
}


#pragma mark - events
- (IBAction)onClickCheckmark:(UIButton *)sender {
    
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    UIButton *checkmark = (UIButton *)[cell viewWithTag:3];
    checkmark.selected = !checkmark.selected;
    
    Itinerary *itinerary = [self getItineraryForRow:indexPath.section row:indexPath.row];
    //set time
    UIButton *time = (UIButton *) [cell viewWithTag:2];
    itinerary.time = time.titleLabel.text;
    
    if(checkmark.selected == YES){ //selecting restaurant
        if(![self hasItinerary:itinerary]){
            [self.selectedItineraries addObject:itinerary];
        }
    }else{ //removing it
        [self removeItinerary:itinerary];
    }
}

- (IBAction)onSelectAllPressed:(UIBarButtonItem *)sender {
    
    for (NSInteger j = 0; j < [self.tableView numberOfSections]; ++j){
        for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:j]; ++i){
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
            UIButton *checkmark = (UIButton *)[cell viewWithTag:3];
            checkmark.selected = YES;
            
            Itinerary *itinerary = [[Itinerary alloc] init];
            UILabel *restaurantName = (UILabel*) [cell viewWithTag:1];
            itinerary.restaurant = restaurantName.text;
            
            UIButton *time = (UIButton *) [cell viewWithTag:2];
            itinerary.time = time.titleLabel.text;
            
            if(![self hasItinerary:itinerary]){
                [self.selectedItineraries addObject:itinerary];
            }
            
            
        }
    }
   
}

- (void)addButtonPressed:(UIButton *)sender{
    
    NSString *message = @"";
    NSString *title = @"";
    
    if(self.selectedItineraries.count > 0){
    
        for(int i = 0; i < self.selectedItineraries.count; i++){
            Itinerary *selectedItinerary = [self.selectedItineraries objectAtIndex:i];
            message = [message stringByAppendingString:[NSString stringWithFormat:@"%@ at %@",selectedItinerary.restaurant, selectedItinerary.time]];
            message = [message stringByAppendingString:@"\n"];
        }
        title = @"Thank You!";
    }else{
        message = @"Please select some restaurants!";
        title = @"Ooops!";
    }
    UIAlertView *addedAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [addedAlert show];
}


- (IBAction)onTimeButtonPressed:(UIButton *)sender {
    
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
    UIButton *timeButton = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    
    UIViewController *viewController = [[UIViewController alloc] init];
    UIView *viewForDatePicker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
    
    self.datepicker = [[CCUIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
    self.datepicker.datePickerMode = UIDatePickerModeTime;
    self.datepicker.hidden = NO;
    self.datepicker.button = timeButton;
    self.datepicker.section = indexPath.section;
    self.datepicker.row = indexPath.row;
    
    //set time for datepicker
    NSDateFormatter *timeOnlyFormatter = [[NSDateFormatter alloc] init];
    [timeOnlyFormatter setDateFormat:@"h:mm a"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *today = [NSDate date];
    NSDateComponents *todayComps = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:today];
    NSDateComponents *comps = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[timeOnlyFormatter dateFromString:timeButton.titleLabel.text]];
    comps.day = todayComps.day;
    comps.month = todayComps.month;
    comps.year = todayComps.year;
    NSDate *itineraryTime = [calendar dateFromComponents:comps];
    self.datepicker.date = itineraryTime;
   
    [self.datepicker addTarget:self action:@selector(onTimeChange:) forControlEvents:UIControlEventValueChanged];
    [viewForDatePicker addSubview:self.datepicker];
    [viewController.view addSubview:viewForDatePicker];
    
    self.popOverForDatePicker = [[WYPopoverController alloc] initWithContentViewController:viewController];
    self.popOverForDatePicker.delegate = self;
    [self.popOverForDatePicker setPopoverContentSize:CGSizeMake(350, 200) animated:YES];
    [self.popOverForDatePicker presentPopoverFromRect:timeButton.bounds inView:timeButton permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown) animated:YES];


}

- (void)onTimeChange:(CCUIDatePicker *)sender{
    
    //update time in cell when datepicker time changes
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    [df setDateFormat:@"h:mm a"];
    NSString *newTime = [df stringFromDate:self.datepicker.date];
    
    UIButton *button = sender.button;
    [button setTitle:newTime forState:UIControlStateNormal];
    
    //update selected itinerary time
    Itinerary *itinerary = [self getItineraryForRow:sender.section row:sender.row];
    itinerary.time = newTime;
    [self updateItineraryTime:itinerary];
}


#pragma mark - wypopover delegates
- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller{
    self.popOverForDatePicker.delegate = nil;
    self.popOverForDatePicker = nil;
}

@end
