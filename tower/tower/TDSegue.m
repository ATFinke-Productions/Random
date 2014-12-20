//
//  TDSegue.m
//  tower
//
//  Created by Andrew on 6/27/13.
//  Copyright (c) 2013 ATFinke Productions Incorperated. All rights reserved.
//

#import "TDSegue.h"

@implementation TDSegue

- (void) perform {
    
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    [src.navigationController pushViewController:dst animated:NO];

}


@end
