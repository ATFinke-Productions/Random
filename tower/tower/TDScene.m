//
//  TDScene.m
//  tower
//
//  Created by Andrew on 6/24/13.
//  Copyright (c) 2013 ATFinke Productions Incorperated. All rights reserved.
//

#import "TDScene.h"

@implementation TDScene {
    NSMutableArray * TDTowersInPlay;
    NSMutableArray * TDEnemiesInPlay;
    NSMutableArray * TDBulletsInPlay;
    NSMutableArray * TDBombsInPlay;
    NSMutableArray * TDLasersInPlay;
    NSMutableArray * TDTowerSpacesInPlay;
    NSArray * waveArray;
    NSMutableDictionary * enemiesLeftToSpawn;
    SKLabelNode * healthLabel;
    SKLabelNode * scoreLabel;
    
    TDTower * selectedTower;
    
    NSTimer * waveTimer;
    int livesLeft;
    int lastTowerSpace;
    int towerSpaceNumber;
    int currentWave;
    float score;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        TDTowersInPlay = [[NSMutableArray alloc]init];
        TDEnemiesInPlay = [[NSMutableArray alloc]init];
        TDBulletsInPlay = [[NSMutableArray alloc]init];
        TDBombsInPlay = [[NSMutableArray alloc]init];
        TDLasersInPlay = [[NSMutableArray alloc]init];
        TDTowerSpacesInPlay = [[NSMutableArray alloc]init];
        
        SKSpriteNode * background = [SKSpriteNode spriteNodeWithImageNamed:@"map"];
        background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addChild:background];
       
        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(start) userInfo:nil repeats:NO];
        
        
        livesLeft = 10;
        
        healthLabel = [SKLabelNode labelNodeWithFontNamed:@""];
        healthLabel.text = @"10";
        healthLabel.horizontalAlignmentMode = NSTextAlignmentLeft;
        healthLabel.position = CGPointMake(40, self.frame.size.height-50);
        [self addChild:healthLabel];

        scoreLabel = [SKLabelNode labelNodeWithFontNamed:@""];
        scoreLabel.text = @"500";
        scoreLabel.horizontalAlignmentMode = NSTextAlignmentRight;
        scoreLabel.position = CGPointMake(150, 20);
        [self addChild:scoreLabel];
        
        score = 500;
        [self initalizeTowerSpaces];
        
        SKShapeNode *shape = [[SKShapeNode alloc] init];
        CGMutablePathRef shapePath = CGPathCreateMutable();
        CGPoint line = CGPointMake(250, 10);
        CGPathAddLines(shapePath, NULL, &line, 2);
        CGPathAddArcToPoint(shapePath, NULL, 20, 20, 260, 20, 20);
        shape.position = CGPointMake(10,95);
        shape.path = shapePath;
        [self addChild:shape];
        
        towerSpaceNumber = 10;
    }
    return self;
}

- (void) start {
    [self startNewWave];
    
}



- (void) initalizeTowerSpaces {
    
    for (int i = 50; i < 300; i = i +65) {
        TDTowerSpace * towerSpace = [[TDTowerSpace alloc]initWithColor:[UIColor darkGrayColor] size:CGSizeMake(20, 20)];
        towerSpace.userInteractionEnabled = YES;
        towerSpace.delegate = self;
        towerSpace.towerSpaceNumber = towerSpaceNumber;
        towerSpaceNumber++;
        towerSpace.position = CGPointMake(i, 150);
        [self addChild:towerSpace];
        [TDTowerSpacesInPlay addObject:towerSpace];
    }
    for (int i = 200; i < 500; i = i +65) {
        TDTowerSpace * towerSpace = [[TDTowerSpace alloc]initWithColor:[UIColor darkGrayColor] size:CGSizeMake(20, 20)];
        towerSpace.userInteractionEnabled = YES;
        towerSpace.delegate = self;
        towerSpace.towerSpaceNumber = towerSpaceNumber;
        towerSpaceNumber++;
        towerSpace.position = CGPointMake(245, i);
        [self addChild:towerSpace];
        [TDTowerSpacesInPlay addObject:towerSpace];
    }
    for (int i = 130; i < 245; i = i +65) {
        TDTowerSpace * towerSpace = [[TDTowerSpace alloc]initWithColor:[UIColor darkGrayColor] size:CGSizeMake(20, 20)];
        towerSpace.userInteractionEnabled = YES;
        towerSpace.delegate = self;
        towerSpace.towerSpaceNumber = towerSpaceNumber;
        towerSpaceNumber++;
        towerSpace.position = CGPointMake(i, 460);
        [self addChild:towerSpace];
        [TDTowerSpacesInPlay addObject:towerSpace];
    }
    for (int i = 200; i < 500; i = i +65) {
        TDTowerSpace * towerSpace = [[TDTowerSpace alloc]initWithColor:[UIColor darkGrayColor] size:CGSizeMake(20, 20)];
        towerSpace.userInteractionEnabled = YES;
        towerSpace.delegate = self;
        towerSpace.towerSpaceNumber = towerSpaceNumber;
        towerSpaceNumber++;
        towerSpace.position = CGPointMake(130, i);
        [self addChild:towerSpace];
        [TDTowerSpacesInPlay addObject:towerSpace];
    }
    
}







- (void) startNewWave{
    if (currentWave == 3) {
        currentWave = 0;
    }
    NSString * wavePlistURL = [[NSBundle mainBundle] pathForResource:@"TDWaveList" ofType:@"plist"];
    waveArray = [[NSArray alloc]initWithContentsOfFile:wavePlistURL];

    NSDictionary * currentWaveProperties = [[NSDictionary alloc] init];
    
    currentWaveProperties = waveArray[currentWave];
    enemiesLeftToSpawn = [[NSMutableDictionary alloc]init];
    enemiesLeftToSpawn = [currentWaveProperties[@"enemyList"] mutableCopy];
    waveTimer = [NSTimer scheduledTimerWithTimeInterval:[currentWaveProperties[@"enemyFrequency"] intValue] target:self selector:@selector(spawnNewEnemy) userInfo:nil repeats:YES];

}

- (void) spawnNewEnemy {
    
    
    int smallEnemies = [enemiesLeftToSpawn[@"smallEnemies"]intValue];
    int mediumEnemies = [enemiesLeftToSpawn[@"mediumEnemies"]intValue];
    int largeEnemies = [enemiesLeftToSpawn[@"largeEnemies"]intValue];
    int extraLargeEnemies = [enemiesLeftToSpawn[@"extraLargeEnemies"]intValue];
    
    
    if (smallEnemies+mediumEnemies+largeEnemies+extraLargeEnemies == 0) {
        [waveTimer invalidate];
        currentWave = currentWave + 1;
        
        [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(startNewWave) userInfo:nil repeats:NO];
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"Wave Complete" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }

    TDEnemy *sprite = [TDEnemy spriteNodeWithImageNamed:@"enemy"];
    sprite.delegate = self;
    sprite.userInteractionEnabled = YES;
    
    double scaleSize;
    
    BOOL hasChoosenUsableEnemyType = NO;
    while (!hasChoosenUsableEnemyType) {

        switch (arc4random() % 4) {
            case 0:
                if (extraLargeEnemies > 0) {
                    sprite.sizeOption = TDSizeOptionXL;
                    scaleSize = .5;
                    sprite.healthLeft = TDSizeXLHeath;
                    extraLargeEnemies--;
                    [enemiesLeftToSpawn setValue:[NSNumber numberWithInt:extraLargeEnemies] forKey:@"extraLargeEnemies"];
                    hasChoosenUsableEnemyType = YES;
                }
                break;
            case 1:
                if (largeEnemies > 0) {
                    sprite.sizeOption = TDSizeOptionL;
                    sprite.healthLeft = TDSizeLHeath;
                    scaleSize = .3;
                    largeEnemies--;
                    [enemiesLeftToSpawn setValue:[NSNumber numberWithInt:largeEnemies] forKey:@"largeEnemies"];
                    hasChoosenUsableEnemyType = YES;
                }
                break;
            case 2:
                if (mediumEnemies > 0) {
                    sprite.sizeOption = TDSizeOptionM;
                    sprite.healthLeft = TDSizeMHeath;
                    scaleSize = .2;
                    mediumEnemies--;
                    [enemiesLeftToSpawn setValue:[NSNumber numberWithInt:mediumEnemies] forKey:@"mediumEnemies"];
                    hasChoosenUsableEnemyType = YES;
                }
                break;
            case 3:
                if (smallEnemies > 0) {
                    sprite.sizeOption = TDSizeOptionS;
                    sprite.healthLeft = TDSizeSHeath;
                    scaleSize = .15;
                    smallEnemies--;
                    [enemiesLeftToSpawn setValue:[NSNumber numberWithInt:smallEnemies] forKey:@"smallEnemies"];
                    hasChoosenUsableEnemyType = YES;
                }
                break;
            default:
                break;
        }
    }

    sprite.xScale = scaleSize;
    sprite.yScale = scaleSize;
    
    
    [self setPathForSprite:sprite];
    [self addChild:sprite];
    [TDEnemiesInPlay addObject:sprite];
}




/*
 OLD CODE
 */


/*
 REMOVE SPRITE
 */

- (void) performDeathActionsForSprite:(TDEnemy *)sprite {

    if (sprite.healthLeft <= 0 && !sprite.isDieing) {
        
        sprite.isDieing = YES;
        
        score = score + sprite.xScale * 100;
        scoreLabel.text = [[NSString stringWithFormat:@"%f",score] substringToIndex:5];
        
        [sprite removeAllActions];
        
        int sideToSideX = arc4random() % 100 - arc4random() % 100;
        int sideToSideY = arc4random() % 100 - arc4random() % 100;
        
        SKAction * randomMovement = [SKAction moveByX:sideToSideX y:sideToSideY duration:4];
        SKAction * fade = [SKAction fadeOutWithDuration:4];
        SKAction * spin = [SKAction rotateByAngle:20 duration:4];
        SKAction * scale = [SKAction scaleTo:0 duration:4];
        SKAction * group = [SKAction group:@[randomMovement,scale,fade,spin]];
        [sprite runAction:group completion:^{
            [TDEnemiesInPlay removeObject:sprite];
            [sprite runAction:[SKAction removeFromParent]];
        }];
    }
}





/*
 SET PATH AND SPEED BASED ON SPRITE SIZE AND WAVE
 */

- (void) setPathForSprite:(TDEnemy *)sprite{

    double ESM = 0.0; //More size = Less speed;
    
    switch (sprite.sizeOption) {
        case TDSizeOptionXL:
            ESM = 5;
            break;
        case TDSizeOptionL:
            ESM = 3;
            break;
        case TDSizeOptionM:
            ESM = 2;
            break;
        case TDSizeOptionS:
            ESM = 1*1.75;
            break;
            
        default:
            break;
    }
    
    
    
    /*
     ENEMY PATH ALONG GRAY LINE FROM BACKGROUND SPRITE
     */
    
    
    double rightAngle = 5*M_1_PI;
    
    sprite.position = CGPointMake(-30, 100);
    
    SKAction * moveStraightRight = [SKAction moveByX:300 y:0 duration:3*ESM];
    
    SKAction * turnLeft = [SKAction rotateByAngle:rightAngle duration:.5*ESM];
    SKAction * moveRightAndUp = [SKAction moveByX:10 y:20 duration:.5*ESM];
    SKAction * firstGroup = [SKAction group:@[turnLeft,moveRightAndUp]];
    
    SKAction * moveStraightUp = [SKAction moveByX:0 y:360 duration:4*ESM];
    
    /* TURN LEFT ACTION */
    SKAction * moveLeftAndUp = [SKAction moveByX:-10 y:20 duration:.5*ESM];
    SKAction * secondGroup = [SKAction group:@[turnLeft,moveLeftAndUp]];
    
    SKAction * moveStraightLeft = [SKAction moveByX:-190 y:0 duration:1.9*ESM];
    
    /* TURN LEFT ACTION */
    SKAction * moveLeftAndDown = [SKAction moveByX:-10 y:-20 duration:.5*ESM];
    SKAction * thirdGroup = [SKAction group:@[turnLeft,moveLeftAndDown]];
    
    SKAction * moveStraightDown = [SKAction moveByX:0 y:-260 duration:2.5*ESM];
    
    SKAction * turnRight = [SKAction rotateByAngle:-rightAngle duration:.5*ESM];
    /* moveLeftAndDown ACTION */
    SKAction * fourthGroup = [SKAction group:@[turnRight,moveLeftAndDown]];
    
    [sprite runAction:[SKAction sequence:@[moveStraightRight,firstGroup,moveStraightUp,secondGroup, moveStraightLeft,thirdGroup,moveStraightDown,fourthGroup,moveStraightLeft]] completion:^{
        if (!sprite.isDieing) {
            [sprite runAction:[SKAction removeFromParent]];
            [TDEnemiesInPlay removeObject:sprite];
            livesLeft--;
            healthLabel.text = [NSString stringWithFormat:@"%i",livesLeft];
            if (livesLeft == 0) {
#warning gameover function
               // [self.delegate gameOverWithFinalScore:score];
            }
        }
    }];
    
     
}

/*
 CALLED EVERY FRAME
 */

-(void)update:(CFTimeInterval)currentTime {
    [self checkTowers];
    [self checkCollisions];

}

/*
 CHECK IF BULLETS HAVE COLLIDED WITH ENEMIES
 */

-(void) checkCollisions {
    NSMutableArray * bulletsToRemove = [[NSMutableArray alloc]init];
    NSMutableArray * lasersToRemove = [[NSMutableArray alloc]init];
    
    for (TDBullet * bullet in TDBulletsInPlay) {
        if (CGRectIntersectsRect(bullet.frame, self.frame)) {
            for (TDEnemy * enemy in TDEnemiesInPlay) {
                if (CGRectIntersectsRect(bullet.frame, enemy.frame) && !enemy.isDieing) {
                    [bulletsToRemove addObject:bullet];
                    enemy.healthLeft = enemy.healthLeft - bullet.damage;
                    [self performDeathActionsForSprite:enemy];
                }
            }
        }
    }
    
    for (TDLaser * laser in TDLasersInPlay) {
        if (CGRectIntersectsRect(laser.frame, self.frame)) {
            for (TDEnemy * enemy in TDEnemiesInPlay) {
                if (CGRectIntersectsRect(laser.frame, enemy.frame) && !enemy.isDieing) {
                    [lasersToRemove addObject:laser];
                    enemy.healthLeft = enemy.healthLeft - laser.damage;
                    [self performDeathActionsForSprite:enemy];
                    NSLog(@"%f",enemy.healthLeft);
                }
            }
        }
    }
    
    for (TDBullet * bullet in bulletsToRemove) {
        [bullet runAction:[SKAction removeFromParent]];
        [TDBulletsInPlay removeObject:bullet];
    }
    
    for (TDLaser * laser in lasersToRemove) {
        [laser runAction:[SKAction removeFromParent]];
        [TDBulletsInPlay removeObject:laser];
    }
}

/*
 CHECK IF ENEMY IN RANGE OF TOWER AND FIRE IF NECESSARY
 */

- (void) checkTowers {
    for (TDTower * tower in TDTowersInPlay) {
        if (tower.canFire) {

            for (TDEnemy * enemy in TDEnemiesInPlay) {
                
                if (!enemy.isDieing) {

                    double  distanceX = (tower.position.x - enemy.position.x);
                    double  distanceY = (tower.position.y - enemy.position.y);
                    
                    double  distanceXSquared = distanceX * distanceX;
                    double  distanceYSquared = distanceY * distanceY;
                    
                    double distance = sqrt(distanceXSquared + distanceYSquared);
                    
                    if (distance < tower.range && tower.canFire) {
                        
                        if (tower.fireType == TDTowerTypeBomb) {
                            TDBomb * bomb = [TDBomb spriteNodeWithImageNamed:@"bullet"];
                            bomb.position = tower.position;
                            bomb.xScale = 0;
                            bomb.yScale = 0;
                            bomb.damage = TDTowerTypeBulletDamage;
                            bomb.range = 50;
                            [self addChild:bomb];
                            [TDBombsInPlay addObject:bomb];
                            
                            SKAction * scale = [SKAction scaleTo:.3 duration:.5];
                            SKAction * scaleDown = [SKAction scaleTo:0 duration:1];
                            
                            SKAction * sequence = [SKAction sequence:@[scale,scaleDown]];
                            
                            SKAction * spin = [SKAction repeatAction:[SKAction rotateByAngle:M_1_PI duration:.1] count:15];
                            SKAction * move = [SKAction moveByX:-distanceX y:-distanceY duration:1.5];
                            
                            SKAction * group = [SKAction group:@[sequence,move,spin]];
                            
                            [bomb runAction:group completion:^{
                                [self bombDidLand:bomb];
                                
                            }];
                            
                            [tower resetCooldown];
                        }
                        else if (tower.fireType == TDTowerTypeBullet) {
                            TDBullet * bullet = [TDBullet spriteNodeWithImageNamed:@"bullet"];
                            bullet.position = tower.position;
                            bullet.xScale = .05;
                            bullet.yScale = .05;
                            bullet.damage = TDTowerTypeBulletDamage;
                            [self addChild:bullet];
                            [TDBulletsInPlay addObject:bullet];
                            
                            
                            SKAction * move = [SKAction moveByX:-distanceX y:-distanceY duration:.1];
                            
                            [bullet runAction:[SKAction sequence:@[[SKAction repeatAction:move count:100],[SKAction removeFromParent]]]completion:^{
                                [TDBulletsInPlay removeObject:bullet];
                            }];
    
                            
                            [tower resetCooldown];
                        }
                        else if (tower.fireType == TDTowerTypeLaser) {
                            TDLaser * bullet = [TDLaser spriteNodeWithImageNamed:@"bullet"];
                            bullet.color = [UIColor blueColor];
                            bullet.colorBlendFactor = .75;
                            bullet.position = tower.position;
                            bullet.xScale = .01;
                            bullet.yScale = .01;
                            bullet.damage = TDTowerTypeLaserDamage;
                            [self addChild:bullet];
                            [TDLasersInPlay addObject:bullet];
                            
                            
                            SKAction * move = [SKAction moveByX:-distanceX y:-distanceY duration:.1];
                            
                            [bullet runAction:[SKAction sequence:@[[SKAction repeatAction:move count:100],[SKAction removeFromParent]]]completion:^{
                                [TDLasersInPlay removeObject:bullet];
                            }];
                            
                            
                            [tower resetCooldown];
                        }
                    }
                }
            } 
        }
    }
}

/*
 PLACE TOWER ON TOUCH
*/ 


- (void) bombDidLand:(TDBomb *)bomb {
    CGPoint landingSpot = bomb.position;
    
    SKEmitterNode * smoke = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:  @"fire" ofType:@"sks"]];
    smoke.position = landingSpot;
    smoke.xScale = .05;
    smoke.yScale = .05;
    //smoke.particlePositionRange = CGPointMake(bomb.range, bomb.range);
    [self addChild:smoke];

    
    SKAction * scaleUp = [SKAction scaleTo:1 duration:.25];
    SKAction * fade = [SKAction group:@[[SKAction fadeAlphaTo:0 duration:2],[SKAction scaleTo:.5 duration:2]]];
    
    SKAction * sequence = [SKAction sequence:@[scaleUp,fade]];
    
    
    [smoke runAction:sequence completion:^{
        [smoke runAction:[SKAction removeFromParent]];
    }];
    
    for (TDEnemy * enemy in TDEnemiesInPlay) {
        if (!enemy.isDieing) {
            
            double  distanceX = (landingSpot.x - enemy.position.x);
            double  distanceY = (landingSpot.y - enemy.position.y);
            
            double  distanceXSquared = distanceX * distanceX;
            double  distanceYSquared = distanceY * distanceY;
            
            double distance = sqrt(distanceXSquared + distanceYSquared);
            
            if (bomb.range >= distance) {
                enemy.healthLeft = enemy.healthLeft - bomb.damage;
                [self performDeathActionsForSprite:enemy];
            }
        }
        
    }
    [TDBombsInPlay removeObject:bomb];
    [bomb removeFromParent];
   
    
}

-(void) towerTapped:(id)sender {
  //  selectedTower = sender;
}

- (void) towerSpacedTapped:(id)sender {
    lastTowerSpace = ((TDTowerSpace*)sender).towerSpaceNumber;

    [self.delegate showScrollViewWithCreditCount:(float)score];
}




- (void) tappedTowerOfType:(NSString *)towerType {
    
    if ([towerType isEqualToString:@"Cannon"]) {
        selectedTower = [TDTower spriteNodeWithImageNamed:@"bombtower"];
        selectedTower.needsCooldown = YES;
        selectedTower.fireType = TDTowerTypeBomb;
        selectedTower.cooldownTime = 5;
        score = score - 200;
        selectedTower.range = 100;
    }
    else if ([towerType isEqualToString:@"Bullet"]) {
        selectedTower = [TDTower spriteNodeWithImageNamed:@"bullettower"];
        selectedTower.needsCooldown = YES;
        selectedTower.fireType = TDTowerTypeBullet;
        selectedTower.cooldownTime = .05;
        score = score - 100;
        selectedTower.range = 100;
    }
    else if ([towerType isEqualToString:@"Laser"]) {
        selectedTower = [TDTower spriteNodeWithImageNamed:@"LaserTower"];
        selectedTower.needsCooldown = NO;
        selectedTower.fireType = TDTowerTypeLaser;
        score = score - 100;
        selectedTower.range = 200;
    }
    
    selectedTower.xScale = .2;
    selectedTower.yScale = .2;
    
    selectedTower.canFire = YES;
    selectedTower.delegate = self;
    selectedTower.userInteractionEnabled = YES;
    
    for (TDTowerSpace * towerSpace in TDTowerSpacesInPlay) {
        if (towerSpace.towerSpaceNumber == lastTowerSpace) {
            selectedTower.position = towerSpace.position;
            towerSpace.hidden = YES;
        }
    }

    [self addChild:selectedTower];
    [TDTowersInPlay addObject:selectedTower];
    scoreLabel.text = [[NSString stringWithFormat:@"%f",score] substringToIndex:5];
    [self.delegate hideScrollView];
}


- (void) enemyTapped:(id)sender {
   
}




























/*
 - (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
 for (UITouch *touch in touches) {
 CGPoint location = [touch locationInNode:self];
 selectedTower.position = CGPointMake(location.x, location.y);
 }
 }
 
 - (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
 for (UITouch *touch in touches) {
 CGPoint location = [touch locationInNode:self];
 selectedTower.position = CGPointMake(location.x, location.y);;
 selectedTower.canFire = YES;
 }
 selectedTower = nil;
 }
 
 - (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
 for (UITouch *touch in touches) {
 CGPoint location = [touch locationInNode:self];
 
 if (towersLeft == 15 || towersLeft == 14) {
 selectedTower = [TDTower spriteNodeWithImageNamed:@"bombtower"];
 selectedTower.fireType = TDFireTypeBomb;
 selectedTower.cooldownTime = 5;
 }
 else {
 selectedTower = [TDTower spriteNodeWithImageNamed:@"bullettower"];
 selectedTower.fireType = TDFireTypeBullet;
 selectedTower.cooldownTime = .05;
 }
 
 selectedTower.xScale = .2;
 selectedTower.yScale = .2;
 selectedTower.range = 100;
 selectedTower.canFire = NO;
 selectedTower.position = CGPointMake(location.x, location.y);
 selectedTower.delegate = self;
 selectedTower.userInteractionEnabled = YES;
 
 for (TDTower * otherTower in TDTowersInPlay) {
 if (CGRectIntersectsRect(selectedTower.frame, otherTower.frame) || towersLeft <= 0) {
 return;
 }
 }
 
 towersLeft --;
 towerLabel.text = [NSString stringWithFormat:@"%i",towersLeft];
 [self addChild:selectedTower];
 [TDTowersInPlay addObject:selectedTower];
 }
 }
 */



@end
