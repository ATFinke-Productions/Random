//
//  TDMyScene.h
//  tower
//

//  Copyright (c) 2013 ATFinke Productions Incorperated. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <QuartzCore/QuartzCore.h>
#import "TDElements.h"

@protocol TDSceneDelegate <NSObject>

@required
- (void) gameOverWithFinalScore:(float)score;
- (void) showScrollViewWithCreditCount:(float)score;
- (void) hideScrollView;
@end




@interface TDScene : SKScene <TDTowerDelegate,TDEnemyDelegate,TDTowerImageViewDelegate,TDTowerSpaceDelegate>


@property (nonatomic) id <TDSceneDelegate> delegate;





@end
