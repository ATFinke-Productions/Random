//
//  TDElements.h
//  tower
//
//  Created by Andrew on 6/24/13.
//  Copyright (c) 2013 ATFinke Productions Incorperated. All rights reserved.
//

#import "TDTower.h"
#import "TDEnemy.h"
#import "TDBullet.h"
#import "TDBomb.h"
#import "TDLaser.h"
#import "TDTowerImageView.h"
#import "TDTowerSpace.h"






typedef NS_ENUM(NSInteger, TDSize) {
    TDSizeOptionXL,
    TDSizeOptionL,
    TDSizeOptionM,
    TDSizeOptionS,
};

typedef NS_ENUM(NSInteger, TDTowerType) {
    TDTowerTypeBullet,
    TDTowerTypeBomb,
    TDTowerTypeLaser,
};

typedef NS_ENUM(NSInteger, TDSizeHealth) {
    TDSizeXLHeath = 5000,
    TDSizeLHeath = 3000,
    TDSizeMHeath = 1500,
    TDSizeSHeath = 500,
};


typedef NS_ENUM(NSInteger, TDTowerDamage) {
    TDTowerTypeBulletDamage = 50,
    TDTowerTypeBombDamage = 2000,
    TDTowerTypeLaserDamage = 1,
};