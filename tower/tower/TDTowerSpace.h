//
//  TDTowerSpace.h
//  tower
//
//  Created by Andrew on 6/28/13.
//  Copyright (c) 2013 ATFinke Productions Incorperated. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol TDTowerSpaceDelegate <NSObject>

@required

- (void) towerSpacedTapped:(id)sender;

@end


@interface TDTowerSpace : SKSpriteNode

@property (nonatomic) id <TDTowerSpaceDelegate> delegate;
@property (nonatomic) int towerSpaceNumber;

@end
