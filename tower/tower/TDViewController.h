//
//  TDViewController.h
//  tower
//

//  Copyright (c) 2013 ATFinke Productions Incorperated. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "TDTowerImageView.h"
#import "TDScene.h"
#import "TDScrollView.h"

@interface TDViewController : UIViewController <TDSceneDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *imageViewsInScroll;
@property (nonatomic, strong) TDScrollView *scrollView;

@end
