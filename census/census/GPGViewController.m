//
//  GPGViewController.m
//  census
//
//  Created by Andrew on 10/18/13.
//  Copyright (c) 2013 ATFinke Productions Incorperated. All rights reserved.
//

#import "GPGViewController.h"

@interface GPGViewController () {
    double maxBarSize;
    NSNumber *highestNumber;
    NSString *maxLabelSize;
    NSMutableArray *categoriesMen;
    NSMutableArray *categoriesWomen;
    NSString *currentId;
}

@end

@implementation GPGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    self.navigationItem.title = @"Downloading Data...";
}

- (void) viewDidAppear:(BOOL)animated {
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    [self downloadPopulationData];
}


- (void)downloadPopulationData {

    highestNumber = [NSNumber numberWithInt:0];
#error Need api key http://api.census.gov/
    NSString *apiKey = @"key";
    
    NSString *stateID = @"01";
    self.navigationItem.title = @"Downloading Data...";
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"stateId"]) {
        stateID = [[NSUserDefaults standardUserDefaults]valueForKey:@"stateId"];
        if ([currentId isEqualToString:stateID]) {
            return;
        }
        currentId = stateID;
        self.navigationItem.title = [NSString stringWithFormat:@"%@ Population Pyramid",[[NSUserDefaults standardUserDefaults]valueForKey:@"stateName"]];
    }
    else {
        self.navigationItem.title = @"Alabama Population Pyramid";
    }
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:[NSString stringWithFormat:@"%@Data",stateID]]) {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults]valueForKey:[NSString stringWithFormat:@"%@Data",stateID]];
        categoriesMen = dict[@"Men"];
        categoriesWomen = dict[@"Women"];

        [self initalizeGraphsForID:stateID];
    }
    else {
        [self startDownloadWithKey:apiKey forID:stateID];
    }
}

- (void) startDownloadWithKey:(NSString*)apiKey forID:(NSString*)stateID {
    BOOL moveToWomen = NO;
    categoriesMen = [NSMutableArray array];
    [categoriesMen addObject:@0];
    categoriesWomen= [NSMutableArray array];
    [categoriesWomen addObject:@0];
    int category = 1;
    int numberInCurrentCategory = 0;
    for (int apiVarible = 120003; apiVarible <= 120209; apiVarible++) {
        if (apiVarible == 120106) {
            moveToWomen = YES;
            apiVarible = 120107;
            category = 1;
            numberInCurrentCategory = 0;
        }
        
        NSString *newUrlString = [NSString stringWithFormat:@"http://api.census.gov/data/2010/sf1?key=%@&get=PCT0%i,NAME&for=state:%@",apiKey,apiVarible,stateID];
        
        NSURL *newUrl = [NSURL URLWithString:newUrlString];
        NSData *newData = [NSData dataWithContentsOfURL:newUrl];
        
        NSString *symbolDataString = [[NSString alloc] initWithData:newData encoding:NSASCIIStringEncoding];
        symbolDataString = [symbolDataString stringByReplacingOccurrencesOfString:@"[" withString:@""];
        symbolDataString = [symbolDataString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        symbolDataString = [symbolDataString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        
        NSArray *ARRAY = [symbolDataString componentsSeparatedByString:@","];
        if (ARRAY.count < 3) {
            self.navigationItem.title = @"Error";
            return;
        }

        NSString *string = ARRAY[3];
        
        NSNumber *number;
        if (moveToWomen) {
            number = categoriesWomen[category-1];
            [categoriesWomen removeObject:number];
        }
        else {
            number = categoriesMen[category-1];
            [categoriesMen removeObject:number];
        }
        
        
        
        if (!number) {
            number = [[NSNumber alloc]init];
        }
        
        number = [NSNumber numberWithInteger:[number integerValue] + [string integerValue]];
        if (moveToWomen) {
            [categoriesWomen addObject:number];
        }
        else {
            [categoriesMen addObject:number];
        }
        
        numberInCurrentCategory++;
        if (numberInCurrentCategory == 10 && category != 10) {
            numberInCurrentCategory = 0;
            if (moveToWomen) {
                [categoriesWomen addObject:@0];
            }
            else {
                [categoriesMen addObject:@0];
            }
            category = category+1;
        }
    }
    [self initalizeGraphsForID:stateID];
}


- (void) initalizeGraphsForID:(NSString*)stateID {
    NSNumber *highNumber = [[NSNumber alloc]init];
    
    for (NSNumber *number in categoriesMen) {
        if ([number integerValue]>[highNumber integerValue]) {
            highNumber = number;
        }
    }
    for (NSNumber *number in categoriesWomen) {
        if ([number integerValue]>[highNumber integerValue]) {
            highNumber = number;
        }
    }
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setRoundingIncrement:[NSNumber numberWithInt:10000]];
    [formatter setRoundingMode:NSNumberFormatterRoundUp];
    int formatted = [[formatter stringFromNumber:highNumber] doubleValue];
    highestNumber = [NSNumber numberWithInt:formatted];
    if(formatted>1000) {
        maxLabelSize = [NSString stringWithFormat:@"%.1fK", (float)formatted/1000];
    }
    if(formatted>1000000) {
        maxLabelSize = [NSString stringWithFormat:@"%.1fM", (float)formatted/1000000];
    }
    
    NSDictionary *dict = [[NSDictionary alloc]initWithObjects:@[categoriesMen,categoriesWomen] forKeys:@[@"Men",@"Women"]];
    
    [[NSUserDefaults standardUserDefaults] setValue:dict forKey:[NSString stringWithFormat:@"%@Data",stateID]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    maxBarSize = CGRectGetMaxX(self.view.frame) - (CGRectGetMidX(self.view.frame) + 40);
    double inital = -(CGRectGetMaxY(self.view.frame));
    inital = inital/(5.3333);
    double change = CGRectGetMaxY(self.view.frame)/12.8;
    for (int y = inital; y > -CGRectGetMidY(self.view.frame)*1.75; y = y - change) {
        int ages = ((y-inital-1)/-change)*10;
        
        UILabel *ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-50, CGRectGetMaxY(self.view.frame)+ y, 100, 20)];
        
        ageLabel.text = [NSString stringWithFormat:@"%i-%i",ages,ages+10];
        if (ages == 80) {
            ageLabel.text = @"80 & Over";
        }
        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 7) {
            ageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        }
        else {
            ageLabel.font = [UIFont systemFontOfSize:14];
        }
        
        ageLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:ageLabel];
        
               
        UIView *blue = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-40, CGRectGetMaxY(self.view.frame)+ y, 0, CGRectGetMaxY(self.view.frame)/15)];
        blue.backgroundColor = [UIColor blueColor];
        [self.view addSubview:blue];
        
        UIView *red = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) + 40, CGRectGetMaxY(self.view.frame)+ y, 0, CGRectGetMaxY(self.view.frame)/15)];
        red.backgroundColor = [UIColor redColor];
        [self.view addSubview:red];
        
        if (ages/10 == 0) {
            ages = ages +10;
        }
        
        double menDistance = ([categoriesMen[(ages/10)-1]doubleValue] / [highestNumber doubleValue])*maxBarSize;
        double womenDistance = ([categoriesWomen[(ages/10)-1]doubleValue] / [highestNumber doubleValue])*maxBarSize;
        
        
        [UIView animateWithDuration:menDistance*2/maxBarSize animations:^{
            blue.frame = CGRectMake(blue.frame.origin.x, blue.frame.origin.y, blue.frame.size.width - menDistance, blue.frame.size.height);
        }];
        [UIView animateWithDuration:womenDistance*2/maxBarSize animations:^{
            red.frame = CGRectMake(red.frame.origin.x, red.frame.origin.y, red.frame.size.width + womenDistance, red.frame.size.height);
        }];
    }
    
    [self insertGraphView];

}

- (void)insertGraphView {
    UIView *viewOne =  [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)-40, 60, 2, CGRectGetMaxY(self.view.frame)-100)];
    viewOne.backgroundColor = [UIColor blackColor];
    [self.view addSubview:viewOne];
    UIView *viewTwo =  [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)+40, 60, 2, CGRectGetMaxY(self.view.frame)-100)];
    viewTwo.backgroundColor = [UIColor blackColor];
    [self.view addSubview:viewTwo];
    
    double lineLength = CGRectGetMaxY(self.view.frame);
    if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad && self.view.frame.size.width == 480)
    {
        lineLength = lineLength/2 - 42;
    }
    else {
        lineLength = lineLength/4 - 6;
    }

    UIView *viewThree =  [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame)+40, CGRectGetMaxY(self.view.frame)-40, CGRectGetMaxY(self.view.frame)-lineLength,2)];
    viewThree.backgroundColor = [UIColor blackColor];
    [self.view addSubview:viewThree];
    UIView *viewFour =  [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame)-40, CGRectGetMaxY(self.view.frame)-lineLength,2 )];
    viewFour.backgroundColor = [UIColor blackColor];
    [self.view addSubview:viewFour];
    
    
    
    
    
    
    
    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.view.frame)-30, 130, 20)];
    leftLabel.text = maxLabelSize;
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 7) {
        leftLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        
    }
    else {
        leftLabel.font = [UIFont systemFontOfSize:18];
    }

    
    [self.view addSubview:leftLabel];
    UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame)-140, CGRectGetMaxY(self.view.frame)-30, 130, 20)];
    rightLabel.text = maxLabelSize;
    rightLabel.textAlignment = NSTextAlignmentRight;
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 7) {
        rightLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        
    }
    else {
        rightLabel.font = [UIFont systemFontOfSize:18];
    }
    
    [self.view addSubview:rightLabel];
}

@end
