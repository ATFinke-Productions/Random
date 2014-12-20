//
//  TDViewController.m
//  tower
//
//  Created by Andrew on 6/24/13.
//  Copyright (c) 2013 ATFinke Productions Incorperated. All rights reserved.
//

#import "TDViewController.h"
#import "TDGameOverViewController.h"


@interface TDViewController () 


@property (nonatomic, strong) NSArray *interestsList;
@property (nonatomic) BOOL scrollViewHidden;

@end

@implementation TDViewController {
    float finalScore;
    TDScene * scene;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
  //  skView.showsDrawCount = YES;
    
    // Create and configure the scene.
    scene = [TDScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.delegate = self;
   /* scene.userInteractionEnabled = NO;
    [scene runAction:[SKAction moveByX:[UIScreen mainScreen].bounds.size.width/2 y:[UIScreen mainScreen].bounds.size.height/2 duration:.001]];
    
    scene.xScale = 0;
    scene.yScale = 0;
    
    [scene runAction:[SKAction group:@[[SKAction scaleTo:1 duration:2],[SKAction moveByX:-skView.frame.size.width/2 y:-skView.frame.size.height/2 duration:2]]] completion:^{
        scene.userInteractionEnabled = YES;
    }];*/

    // Present the scene.
    [skView presentScene:scene];
    
    
    [self loadScrollView];
}

- (void) loadScrollView {
    self.interestsList = [[NSArray alloc]initWithObjects:@"Bullet",@"Cannon",@"Laser", nil];
    
    NSUInteger numberPages = self.interestsList.count;
    
    NSMutableArray * placeHolders = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < numberPages; i++)
    {
		[placeHolders addObject:[TDTowerImageView new]];
    }
    self.imageViewsInScroll = placeHolders;
    
    
    self.scrollView = [[TDScrollView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 25, self.view.bounds.size.width, 25)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize =
    CGSizeMake(70 * numberPages, CGRectGetHeight(self.scrollView.frame));
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    [self hideScrollView];
    self.scrollView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.5];
    [self.view addSubview:self.scrollView];
    
    for (int i = 0; i < self.interestsList.count; i++) {
        [self loadScrollViewWithPage:i];
    }
}

- (void)loadScrollViewWithPage:(NSUInteger)page
{
    
    if (page >= self.interestsList.count) {
        return;
    }
    
    TDTowerImageView * interestImage = (self.imageViewsInScroll)[page];
    interestImage.tag = 5;
    interestImage.contentMode = UIViewContentModeScaleAspectFit;
    
    if (!interestImage.image){
        if ([self.interestsList[page] isEqualToString:@"Bullet"]) {
            interestImage.image = [UIImage imageNamed:@"bullettower"];
            interestImage.towerCost = 50;
        }
        else if ([self.interestsList[page] isEqualToString:@"Cannon"]){
            interestImage.image = [UIImage imageNamed:@"bombtower"];
            interestImage.towerCost = 200;
        }
        else if ([self.interestsList[page] isEqualToString:@"Laser"]){
            interestImage.image = [UIImage imageNamed:@"LaserTower"];
            interestImage.towerCost = 10;
        }
    }
    if (interestImage.superview == nil)
    {
        CGRect frame = CGRectMake(70 * page, 0, 20, self.scrollView.bounds.size.height);
        interestImage.frame = frame;
        [self.scrollView addSubview:interestImage];
    }
    interestImage.towerType = self.interestsList[page];
    interestImage.delegate = scene;
    interestImage.userInteractionEnabled = YES;
}


- (void) showScrollViewWithCreditCount:(float)score{
    for (TDTowerImageView * imageView in self.scrollView.subviews) {
        if (imageView.tag == 5) {
            if (score < imageView.towerCost) {
                imageView.hidden = YES;
            }
            else {
                imageView.hidden = NO;
            }
        }
    }
    if (self.scrollViewHidden) {
        self.scrollViewHidden = NO;
        [UIView animateWithDuration:.5 animations:^{
            self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y - 50, self.view.bounds.size.width, 25);
        }completion:^(BOOL finished) {
        }];
    }
}

- (void) hideScrollView {
    self.scrollViewHidden = YES;
    [UIView animateWithDuration:.5 animations:^{
        self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y + 50, self.view.bounds.size.width, 25);
    }completion:^(BOOL finished) {
        
    }];
}

- (void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    [self hideScrollView];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void) gameOverWithFinalScore:(float)score {
    finalScore = score;
    [self performSegueWithIdentifier:@"gameOver" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ((SKView *)self.view).paused = YES;
    [[segue destinationViewController] setScoreItem:[NSString stringWithFormat:@"%f",finalScore]];
}


@end
