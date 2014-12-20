//
//  Bubble.h
//  bubbles
//
//  Created by Andrew on 9/7/13.
//  Copyright (c) 2013 ATFinke Productions Incorperated. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BubbleDelegate <NSObject>
@required
- (void) bubbleTouched:(id)sender;
@end

@interface Bubble : UIView

@property (nonatomic) id <BubbleDelegate> delegate;

@end
