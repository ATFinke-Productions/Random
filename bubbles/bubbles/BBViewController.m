//
//  BBViewController.m
//  bubbles
//
//  Created by Andrew on 9/7/13.
//  Copyright (c) 2013 ATFinke Productions Incorperated. All rights reserved.
//

#import "BBViewController.h"

@interface BBViewController ()
@end

@implementation BBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(createNewBubble) userInfo:nil repeats:YES];
    [self updateLabel];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
    
    UINavigationBar *navigationBar = [[self navigationController] navigationBar];
    CGRect frame = [navigationBar frame];
    frame.size.height = 872.0f;
    [navigationBar setFrame:frame];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void) updateLabel {
    NSDate *now = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"h:mm"];
	self.clockLabel.text = [dateFormatter stringFromDate:now];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createNewBubble {
    Bubble *bubble = [[Bubble alloc]initWithFrame:CGRectMake((arc4random() % 320)-12.5, [UIScreen mainScreen].bounds.size.height+40, 60, 60)];
    bubble.layer.cornerRadius = 30;
    
    bubble.backgroundColor = [self randomColor];
    bubble.alpha = ((arc4random() % 50)/100) +.5;
    
    [self addAnimationToBubble:bubble];
    [self.view addSubview:bubble];
    [self.view sendSubviewToBack:bubble];
}

- (UIColor *) randomColor {
    switch (arc4random() % 7) {
        case 0:
            return [UIColor redColor];
            break;
        case 1:
            return [UIColor blueColor];
            break;
        case 2:
            return [UIColor purpleColor];
            break;
        case 3:
            return [UIColor greenColor];
            break;
        case 4:
            return [UIColor magentaColor];
            break;
        case 5:
            return [UIColor orangeColor];
            break;
        case 6:
            return [UIColor yellowColor];
            break;
            
        default:
            break;
    }
    return [UIColor whiteColor];
}

- (void) addAnimationToBubble:(Bubble*)bubble {
    [UIView animateWithDuration:(arc4random() % 3) + 1
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         CGPoint bubblePoint = bubble.frame.origin;
                         int randomNumber = bubblePoint.y - arc4random() % 100;
                         bubble.frame = CGRectMake([self randomXForPoint:bubblePoint], randomNumber, 60, 60);
                     }
                     completion:^(BOOL finished) {
                         if (bubble.frame.origin.y < -50) {
                             if (bubble.alpha != 0) {
                                 [UIView animateWithDuration:1 animations:^{
                                     bubble.alpha = 0;
                                 } completion:^(BOOL finished) {
                                     [bubble removeFromSuperview];
                                 }];
                             }
                             else {
                                 [bubble removeFromSuperview];
                             }
                         }
                         else {
                             [self addAnimationToBubble:bubble];
                         }
                     }];
}

- (int) randomXForPoint:(CGPoint)point {
    BOOL isPositive = YES;
    if (arc4random() % 2 == 0) {
        isPositive = NO;
    }
    CGFloat bubblePoint = point.x;
    
    if (isPositive) {
        return bubblePoint + arc4random() % 50;
    }
    return bubblePoint - arc4random() % 50;
}


@end
