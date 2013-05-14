//
//  DemosViewController.m
//  GKitDemo
//
//  Created by Glare on 13-4-23.
//  Copyright (c) 2013年 Hoewo. All rights reserved.
//

#import "DemosViewController.h"
#import "GCore.h"
#import "GNavigationViewController.h"

#define kNumberOfSections @"NumberOfSections"

@interface DemosViewController ()
@property (nonatomic, strong) NSMutableDictionary *listInfo;
@end

@implementation DemosViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _listInfo = [NSMutableDictionary dictionary];
    [_listInfo setValue:GNumberWithInteger(5) forKey:kNumberOfSections];
    
    [_listInfo setValue:@[@"Audio"] forKey:@"0"];
    [_listInfo setValue:@[@"Camera"] forKey:@"1"];
    [_listInfo setValue:@[@"Calendar"] forKey:@"2"];
    [_listInfo setValue:@[@"CustomUI"] forKey:@"3"];
    [_listInfo setValue:@[@"Present"] forKey:@"4"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[_listInfo valueForKey:kNumberOfSections] integerValue];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_listInfo valueForKey:[NSString stringWithFormat:@"%d",section]] count];
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [[_listInfo valueForKey:[NSString stringWithFormat:@"%d",indexPath.section]] objectAtPosition:indexPath.row];
    if (title) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell.textLabel setText:title];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [[_listInfo valueForKey:[NSString stringWithFormat:@"%d",indexPath.section]] objectAtPosition:indexPath.row];
    if (title) {
        UIViewController *controller = [NSClassFromString([NSString stringWithFormat:@"%@ViewController",title]) new];
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }
}


@end
