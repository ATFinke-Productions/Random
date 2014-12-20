//
//  Bubble.m
//  bubbles
//
//  Created by Andrew on 9/7/13.
//  Copyright (c) 2013 ATFinke Productions Incorperated. All rights reserved.
//

#import "Bubble.h"

@implementation Bubble

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate bubbleTouched:self];
}

@end
