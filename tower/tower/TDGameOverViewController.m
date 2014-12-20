//
//  TDGameOverViewController.m
//  tower
//
//  Created by Andrew on 6/27/13.
//  Copyright (c) 2013 ATFinke Productions Incorperated. All rights reserved.
//

#import "TDGameOverViewController.h"

@interface TDGameOverViewController ()

@end

@implementation TDGameOverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setScoreItem:(id)newScoreItem
{
    if (_scoreItem != newScoreItem) {
        _scoreItem = newScoreItem;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    _label.text = [NSString stringWithFormat:@"You earned %@ coins",_scoreItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
