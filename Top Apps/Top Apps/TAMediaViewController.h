//
//  TAMediaViewController.h
//  Top Apps
//
//  Created by Andrew on 9/7/13.
//  Copyright (c) 2013 ATFinke Productions Incorperated. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface TAMediaViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (nonatomic) UISegmentedControl *optionsController;
@property (nonatomic) UILabel *titleLabel;

@end
