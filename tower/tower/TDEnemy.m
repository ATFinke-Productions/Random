//
//  TDEnemy.m
//  tower
//
//  Created by Andrew on 6/24/13.
//  Copyright (c) 2013 ATFinke Productions Incorperated. All rights reserved.
//

#import "TDEnemy.h"

@implementation TDEnemy

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate enemyTapped:self];
}

@end
