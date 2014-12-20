//
//  TDEnemy.h
//  tower
//
//  Created by Andrew on 6/24/13.
//  Copyright (c) 2013 ATFinke Productions Incorperated. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol TDEnemyDelegate <NSObject>

@required

- (void) enemyTapped:(id)sender;

@end

@interface TDEnemy : SKSpriteNode

@property (nonatomic) double damagePerHit;
@property (nonatomic) double healthLeft;

@property (nonatomic) int sizeOption;
@property (nonatomic) int speedOption;

@property (nonatomic) BOOL isDieing;

@property (nonatomic) id <TDEnemyDelegate> delegate;

@end
