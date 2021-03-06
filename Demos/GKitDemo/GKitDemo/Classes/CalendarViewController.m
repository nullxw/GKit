//
//  CalendarViewController.m
//  GKitDemo
//
//  Created by Glare on 13-4-24.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "CalendarViewController.h"
#import "GCore.h"
#import "GMove.h"
#import "GCalendar.h"
#import "GNavigationController.h"

@interface CalendarViewController ()
<GDayViewDataSource, GDayViewDelegate,
 GWeekViewDataSource, GWeekViewDelegate>

@property (nonatomic, strong) GDayView *dayView;
@property (nonatomic, strong) GWeekView *weekView;
@property (nonatomic, strong) GMonthView *monthView;

@end

@implementation CalendarViewController

- (void)customInitialize
{
    [super customInitialize];
}

- (void)loadView
{
    self.view = [[GMoveScene alloc] initWithFrame:GScreenBounds()];
    self.view.autoresizingMask = GViewAutoresizingFlexibleSize;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setTopViewHeight:60];
    [self.topView setBackgroundColor:GRandomColor()];
    
    [self setBottomViewHeight:60];
    [self.bottomView setBackgroundColor:GRandomColor()];
    
    self.dayView = [[GDayView alloc] initWithFrame:self.contentView.bounds];
    _dayView.gridLineColor = [UIColor redColor];
    _dayView.showGirdHalfHourLines = NO;
    _dayView.isGridHalfLineDashed = NO;
    _dayView.hourViewBackgroundColor = [UIColor redColor];
    _dayView.showHalfHours = NO;
    _dayView.centerHours = NO;
    _dayView.hourHeight = 72.0f;
    _dayView.hourTextColor = GRandomColor();
    
    self.weekView = [[GWeekView alloc] initWithFrame:self.contentView.bounds];
    _weekView.firstWeekday = GWeekdayTypeMonday;
    _weekView.gridLineColor = [UIColor redColor];
    _weekView.showGirdHalfHourLines = NO;
    _weekView.isGridHalfLineDashed = NO;
    _weekView.hourViewBackgroundColor = [UIColor redColor];
    _weekView.showHalfHours = NO;
    _weekView.centerHours = NO;
    _weekView.hourHeight = 72.0f;
    _weekView.hourTextColor = GRandomColor();
    _weekView.dayViewHeight = 20;
    _weekView.dayTitleBottomMargin = 2;
    _weekView.weekdayColor = GRandomColor();
    _weekView.todayColor = GRandomColor();
    
    self.monthView = [[GMonthView alloc] initWithFrame:self.contentView.bounds];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"日",@"周",@"月"]];
    [segmentedControl setWidth:200];
    segmentedControl.center = self.topView.innerCenter;
    [segmentedControl addTarget:self action:@selector(changeCalenderType:) forControlEvents:UIControlEventValueChanged];
    [self.topView addSubview:segmentedControl];
    [segmentedControl setSelectedSegmentIndex:1];
    
    
    UIButton * firstWeekdayButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [firstWeekdayButton setFrame:CGRectMake(0, 0, 60, 40)];
    [firstWeekdayButton setTitle:GLocalizedString(@"Monday") forState:UIControlStateNormal];
    [firstWeekdayButton addTarget:self action:@selector(firstWeekdayButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:firstWeekdayButton];
    
}

- (void)firstWeekdayButtonDidPress:(UIButton *)firstWeekdayButton {
    if ([[firstWeekdayButton titleForState:UIControlStateNormal] isEqualToString:GLocalizedString(@"Monday")]) {
        [firstWeekdayButton setTitle:GLocalizedString(@"Sunday") forState:UIControlStateNormal];
        
        self.weekView.firstWeekday = GWeekdayTypeSunday;
    }
    else {
        [firstWeekdayButton setTitle:GLocalizedString(@"Monday") forState:UIControlStateNormal];
        
        self.weekView.firstWeekday = GWeekdayTypeMonday;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self changeCalenderType:[[self.topView subviews] objectAtIndex:0]];
}

#pragma mark - Action
- (void)changeCalenderType:(UISegmentedControl *)control
{
    if (control.selectedSegmentIndex==0) {
        [self.weekView removeFromSuperview];
        [self.monthView removeFromSuperview];
        
        self.dayView.dataSource = self;
        self.dayView.delegate = self;
        [self.contentView addSubviewToFill:self.dayView];
        [self.dayView jumpToToday];
        
    }else if (control.selectedSegmentIndex==1) {
        [self.dayView removeFromSuperview];
        [self.monthView removeFromSuperview];
        
        self.weekView.dataSource = self;
        self.weekView.delegate = self;
        [self.contentView addSubviewToFill:self.weekView];
        [self.weekView jumpToToday];

        //显示今日
        
    }else {
        [self.dayView removeFromSuperview];
        [self.monthView removeFromSuperview];
        
        [self.contentView addSubview:self.monthView];
    }
}

#pragma mark - GDayViewDatasource / Delegate
- (NSArray *)eventsForDayView:(GDayView *)dayView
{
    NSMutableArray *events = [NSMutableArray array];
    
    //-03:00 to 01:00
    GEvent *event = [[GEvent alloc] init];
    event.title = @"test -03:00 to 01:00";
    event.beginTime = [NSDate dateWithTimeInterval: -GTimeIntervalFromHours(3)
                                         sinceDate: dayView.day];
    event.endTime = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(1)
                                       sinceDate: dayView.day];
    [events addObject:event];
    
    // 21:00 to 25:00
    event = [[GEvent alloc] init];
    event.title = @"test 21:00 to 25:00";
    event.beginTime = [NSDate dateWithTimeInterval: -GTimeIntervalFromHours(3)
                                         sinceDate: dayView.nextDay];
    event.endTime = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(1)
                                       sinceDate: dayView.nextDay];
    [events addObject:event];
    
    //08:00 to 11:30
    event = [[GEvent alloc] init];
    event.title = @"test 08:00 to 11:30";
    event.beginTime = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(8)
                                         sinceDate: dayView.day];
    event.endTime = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(11.5)
                                       sinceDate: dayView.day];
    [events addObject:event];
    
    //10:00 to 12:00
    event = [[GEvent alloc] init];
    event.title = @"test 10:00 to 12:00";
    event.beginTime = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(10)
                                         sinceDate: dayView.day];
    event.endTime = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(12)
                                       sinceDate: dayView.day];
    [events addObject:event];
    
    
    //13:00 to 18:00
    event = [[GEvent alloc] init];
    event.title = @"test 13:00 to 18:00";
    event.beginTime = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(13)
                                         sinceDate: dayView.day];
    event.endTime = [NSDate dateWithTimeInterval: GTimeIntervalFromHours(18)
                                       sinceDate: dayView.day];
    [events addObject:event];
    
    return events;
}

- (void)dayView:(GDayView *)dayView didSelectGEvent:(GEvent *)event
{
    GViewController *eventVC = [GViewController new];
    eventVC.title = event.title;
    [self.navigationController pushViewController:eventVC animated:YES];
}

- (void)dayView:(GDayView *)dayView didTapAtDate:(NSDate *)date {
    [[[UIAlertView alloc] initWithTitle:@"GDayView"
                                message:[NSString stringWithFormat:@"Did tap %@", date]
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (GEvent *)dayView:(GDayView *)dayView requireGEventAtDate:(NSDate *)date
{
	GEvent *event = [[GEvent alloc] init];
    event.title = @"long press added event";
    event.beginTime = [date dateByAddingTimeInterval:GTimeIntervalFromMinitues(-30)];
    event.endTime = [date dateByAddingTimeInterval:GTimeIntervalFromMinitues(30)];
	return event;
}

- (void)dayView:(GDayView *)dayView didUpdateGEvent:(GEvent *)gEvent {
	if (gEvent.isLongPresAdded) {
		[self dayView:dayView didSelectGEvent:gEvent];
	}
}

#pragma mark - GWeekView
- (NSArray *)eventsForWeekView:(GWeekView *)weekView
{
    NSMutableArray *events = [NSMutableArray array];

    GEvent *event = [[GEvent alloc] init];
    event.title = @"0 03:00 to 0 10:00";
    event.beginTime = [weekView.beginningOfWeek dateByAddingTimeInterval:GTimeIntervalFromHours(3)];
    event.endTime = [weekView.beginningOfWeek dateByAddingTimeInterval:GTimeIntervalFromHours(10)];
    [events addObject:event];
    
    event = [[GEvent alloc] init];
    event.title = @"0 21:00 to 1 05:00";
    event.beginTime = [weekView.beginningOfWeek dateByAddingTimeInterval:GTimeIntervalFromHours(21)];
    event.endTime = [weekView.beginningOfWeek dateByAddingTimeInterval:GTimeIntervalFromHours(5+GHoursInDay)];
    [events addObject:event];

    
    event = [[GEvent alloc] init];
    event.title = @"1 02:00 to 1 06:00";
    event.beginTime = [weekView.beginningOfWeek dateByAddingTimeInterval:GTimeIntervalFromHours(2+GHoursInDay)];
    event.endTime = [weekView.beginningOfWeek dateByAddingTimeInterval:GTimeIntervalFromHours(6+GHoursInDay)];
    [events addObject:event];

    
    event = [[GEvent alloc] init];
    event.title = @"3 08:00 to 3 11:30";
    event.beginTime = [weekView.beginningOfWeek dateByAddingTimeInterval:GTimeIntervalFromHours(8+GHoursInDay*3)];
    event.endTime = [weekView.beginningOfWeek dateByAddingTimeInterval:GTimeIntervalFromHours(11.5+GHoursInDay*3)];
    [events addObject:event];
    
    event = [[GEvent alloc] init];
    event.title = @"3 10:00 to 3 12:00";
    event.beginTime = [weekView.beginningOfWeek dateByAddingTimeInterval:GTimeIntervalFromHours(10+GHoursInDay*3)];
    event.endTime = [weekView.beginningOfWeek dateByAddingTimeInterval:GTimeIntervalFromHours(12+GHoursInDay*3)];
    [events addObject:event];
    
    
    event = [[GEvent alloc] init];
    event.title = @"5 00:00 to 6 24:00";
    event.beginTime = [weekView.beginningOfWeek dateByAddingTimeInterval:GTimeIntervalFromHours(0+GHoursInDay*5)];
    event.endTime = [weekView.beginningOfWeek dateByAddingTimeInterval:GTimeIntervalFromHours(24+GHoursInDay*6)];
    [events addObject:event];
    
    return events;
}

- (void)weekView:(GDayView *)dayView didSelectGEvent:(GEvent *)event
{
    GViewController *eventVC = [GViewController new];
    eventVC.title = event.title;
    [self.navigationController pushViewController:eventVC animated:YES];
}

- (void)weekView:(GWeekView *)weekView didSelectGEvents:(NSArray *)gEvents {
    [[[UIAlertView alloc] initWithTitle:@"GWeekView"
                                message:[NSString stringWithFormat:@"Count of tapped events is %d", gEvents.count]
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)weekView:(GWeekView *)weekView didTapAtDate:(NSDate *)date {
    [[[UIAlertView alloc] initWithTitle:@"GWeekView"
                                message:[NSString stringWithFormat:@"Did tap %@", date]
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (GEvent *)weekView:(GWeekView *)weekView requireGEventAtDate:(NSDate *)date
{
	GEvent *event = [[GEvent alloc] init];
    event.title = @"long press added event";
    event.beginTime = [date dateByAddingTimeInterval:GTimeIntervalFromMinitues(-30)];
    event.endTime = [date dateByAddingTimeInterval:GTimeIntervalFromMinitues(30)];
	return event;

//    [[[UIAlertView alloc] initWithTitle:@"GWeekView"
//                                message:[date dateStringWithFormat:@"yyyy-MM-dd HH:mm:SS"]
//                               delegate:nil
//                      cancelButtonTitle:@"OK"
//                      otherButtonTitles:nil] show];
}

- (void)weekView:(GWeekView *)weekView didUpdateGEvent:(GEvent *)event {
	if (event.isLongPresAdded) {
		[self weekView:weekView didSelectGEvent:event];
	}
}

#pragma mark - GMove
- (void)didPrepareSnapshot:(GMoveSnapshot *)snapshot
{
    GEvent *event = [[GEvent alloc] init];
    [snapshot becomeCatchableInCalendarWithGEvent:event];
}


@end

