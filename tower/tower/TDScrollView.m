//
//  TDScrollView.m
//  tower
//
//  Created by Andrew on 6/28/13.
//  Copyright (c) 2013 ATFinke Productions Incorperated. All rights reserved.
//

#import "TDScrollView.h"

@implementation TDScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.delegate scrollViewDidEndZooming:nil withView:nil atScale:0];
}

@end
