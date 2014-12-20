//
//  TDTower.m
//  tower
//
//  Created by Andrew on 6/24/13.
//  Copyright (c) 2013 ATFinke Productions Incorperated. All rights reserved.
//

#import "TDTower.h"

@implementation TDTower {
    NSTimer * cooldown;
    int secondsUntilFire;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate towerTapped:self];
    self.canFire = NO;
    [cooldown invalidate];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate touchesMoved:touches withEvent:event];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate touchesEnded:touches withEvent:event];
}


- (void) resetCooldown {
    if (self.needsCooldown) {
        self.canFire = NO;
        cooldown = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countCool) userInfo:nil repeats:YES];
        secondsUntilFire = self.cooldownTime;
    }
}

- (void) countCool {
    secondsUntilFire--;
    if (secondsUntilFire <= 0) {
        [cooldown invalidate];
        self.canFire = YES;
    }
}

@end
