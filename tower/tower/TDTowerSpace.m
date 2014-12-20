//
//  TDTowerSpace.m
//  tower
//
//  Created by Andrew on 6/28/13.
//  Copyright (c) 2013 ATFinke Productions Incorperated. All rights reserved.
//

#import "TDTowerSpace.h"

@implementation TDTowerSpace

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate towerSpacedTapped:self];
}

@end
