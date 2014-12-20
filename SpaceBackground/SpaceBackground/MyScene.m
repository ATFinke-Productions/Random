//
//  MyScene.m
//  SpaceBackground
//
//  Created by Andrew on 12/6/13.
//  Copyright (c) 2013 Andrew. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [NSColor blackColor];
        
        SKEmitterNode * stars = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"MenuStars" ofType:@"sks"]];
        stars.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        stars.particlePositionRange = CGVectorMake(self.frame.size.width, self.frame.size.height);
        [self addChild:stars];
        
        
    }
    return self;
}



-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
