//
//  BBStockViewController.m
//  bubbles
//
//  Created by Andrew on 9/8/13.
//  Copyright (c) 2013 ATFinke Productions Incorperated. All rights reserved.
//

#import "BBStockViewController.h"

@interface BBStockViewController () {
    NSMutableData *responseData;
    double savedChange;
    double savedTradeSize;
    int lastBubbleSize;
}

@end

@implementation BBStockViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   // [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(createNewBubble) userInfo:nil repeats:YES];
    [self updateLabel];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateData) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view, typically from a nib.
    savedChange = -1.73;
    savedTradeSize = 32000;
    lastBubbleSize = 60;
}

- (void) updateLabel {
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self performSegueWithIdentifier:@"clock" sender:self];
}



- (void) updateData {
    
    NSString *symbol = @"AAPL";
    
    responseData = [NSMutableData data];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://download.finance.yahoo.com/d/quotes.csv?s=%@&f=l1p2k3&e",symbol]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}


-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [responseData setLength:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [responseData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@",[error localizedFailureReason]);
}


-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSString * symbolDataString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    NSArray * symbolArray = [symbolDataString componentsSeparatedByString:@","];
    
    if (symbolArray.count < 2 || [symbolArray[0] isEqualToString:@"0.00"]) {
        NSLog(@"Symbol Invalid");
        return;
    }
    
    
    NSString *currentChange = symbolArray[1];
    
    currentChange = [currentChange substringFromIndex:1];
    currentChange = [currentChange substringToIndex:currentChange.length-2];

    double lastChange = [currentChange doubleValue];
    
    NSString *lastSizeString = symbolArray[2];
    if (symbolArray.count > 3) {
        lastSizeString = [NSString stringWithFormat:@"%@%@",lastSizeString,symbolArray[3]];
    }
    
    double lastTradeSize = [lastSizeString doubleValue];
    
    if (lastTradeSize == 0) {
        self.priceLabel.text = @"Market Not Open";
        self.dataLabel.text = symbolDataString;
        return;
    }
    else {
        self.dataLabel.text = @"";
    }
    
    
    double tradeDifference = lastTradeSize/savedTradeSize;
    tradeDifference = tradeDifference/1.5;
    
    int newSize = 60*tradeDifference;
    
    if (newSize > 150) {
        newSize = 150;
    }
    
   
    lastBubbleSize = newSize;
    savedTradeSize = lastTradeSize;
    
    if (lastChange < savedChange) {
        double difference = savedChange - lastChange;
        
        NSString *substring = [NSString stringWithFormat:@"%f",difference*100];
        substring = [substring substringToIndex:1];
        
        for (int i = [substring intValue]; i > 0; i--) {
            [self createNewBubbleForColor:[UIColor redColor] forSize:newSize];
        }
  
    }
    else if (lastChange > savedChange) {
        double difference = lastChange - savedChange;
        
        NSString *substring = [NSString stringWithFormat:@"%f",difference*100];
        substring = [substring substringToIndex:1];

        for (int i = [substring intValue]; i > 0; i--) {
           [self createNewBubbleForColor:[UIColor greenColor] forSize:newSize];
        }
    }
    else {
        [self createNewBubbleForColor:[UIColor darkGrayColor] forSize:newSize];
    }
    
    savedChange = lastChange;
    self.priceLabel.text = [NSString stringWithFormat:@"$ %@",symbolArray[0]];
}




























- (void) createNewBubbleForColor:(UIColor*)color forSize:(int)size{
    
    Bubble *bubble = [[Bubble alloc]initWithFrame:CGRectMake((arc4random() % 320)-12.5, [UIScreen mainScreen].bounds.size.height+40, size, size)];
    bubble.layer.cornerRadius = size/2;
    
    bubble.backgroundColor = color;
    bubble.alpha = ((arc4random() % 50)/100) +.5;
    
    [self addAnimationToBubble:bubble];
    [self.view addSubview:bubble];
    [self.view sendSubviewToBack:bubble];
}

- (void) addAnimationToBubble:(Bubble*)bubble {
    [UIView animateWithDuration:(arc4random() % 3) + 1
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         CGPoint bubblePoint = bubble.frame.origin;
                         int randomNumber = bubblePoint.y - arc4random() % 100;
                         bubble.frame = CGRectMake([self randomXForPoint:bubblePoint], randomNumber, bubble.frame.size.height, bubble.frame.size.height);
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
