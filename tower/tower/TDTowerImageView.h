//
//  TDTowerImageView.h
//  tower
//
//  Created by Andrew on 6/28/13.
//  Copyright (c) 2013 ATFinke Productions Incorperated. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TDTowerImageViewDelegate <NSObject>

@required

- (void) tappedTowerOfType:(NSString *)towerType;

@end

@interface TDTowerImageView : UIImageView

@property (nonatomic) NSString * towerType;
@property (nonatomic) int towerCost;
@property (nonatomic) id <TDTowerImageViewDelegate> delegate;

@end
