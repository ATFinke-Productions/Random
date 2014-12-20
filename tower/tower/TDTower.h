//
//  TDTower.h
//  tower
//
//  Created by Andrew on 6/24/13.
//  Copyright (c) 2013 ATFinke Productions Incorperated. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol TDTowerDelegate <NSObject>

@required

- (void) towerTapped:(id)sender;
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end


@interface TDTower : SKSpriteNode

@property (nonatomic) double damagePerHit;
@property (nonatomic) double healthLeft;
@property (nonatomic) int cooldownTime;
@property (nonatomic) double range;
@property (nonatomic) int fireType;

@property (nonatomic) BOOL needsCooldown;
@property (nonatomic) BOOL canFire;

@property (nonatomic) id <TDTowerDelegate> delegate;

- (void) resetCooldown;

@end
