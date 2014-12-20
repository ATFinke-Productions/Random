//
//  StateTableViewController.m
//  census
//
//  Created by Andrew on 11/2/13.
//  Copyright (c) 2013 ATFinke Productions Incorperated. All rights reserved.
//

#import "StateTableViewController.h"

@interface StateTableViewController () {
    NSArray *plistArray;
}

@end

@implementation StateTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"StateList" ofType:@"plist"];
    plistArray = [NSArray arrayWithContentsOfFile:plistPath];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return plistArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *object = plistArray[indexPath.row];
    cell.textLabel.text = object[@"State"];
    
    cell.detailTextLabel.text = @"";
    NSString *stateID = object[@"Id"];
    if ([[NSUserDefaults standardUserDefaults]valueForKey:[NSString stringWithFormat:@"%@Data",stateID]]) {
        cell.detailTextLabel.text = @"Downloaded";
    }

    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSUserDefaults standardUserDefaults]setValue:(NSDictionary*)plistArray[indexPath.row][@"Id"] forKey:@"stateId"];
    [[NSUserDefaults standardUserDefaults]setValue:(NSDictionary*)plistArray[indexPath.row][@"State"] forKey:@"stateName"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
