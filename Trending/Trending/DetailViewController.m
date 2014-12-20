
//
//  DetailViewController.m
//  Trending
//
//  Created by Andrew on 12/1/13.
//  Copyright (c) 2013 Andrew. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentItem = [[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentData"];
    self.navigationItem.title = [NSString stringWithFormat:@"%@ (%@)",self.currentItem[@"title"],self.currentItem[@"year"]];
    
    NSLog(@"%@",self.currentItem);
    [self loadPoster];
    [self loadRating];
    [self loadTextView];
    [self loadIMDB];
    // Do any additional setup after loading the view.
}

- (void) loadRating {
    NSString *textToSet = [NSString stringWithFormat:@"Rated %@",self.currentItem[@"certification"]];
    
    if ([self.currentItem[@"certification"] isEqualToString:@""]) {
        textToSet = @"No Rating";
    }

    self.ratingLabel.text = textToSet;
}
- (void) loadTextView {
    
    NSString *textToSet = [NSString stringWithFormat:@"Overview:\n    %@",self.currentItem[@"overview"]];
    
    textToSet = [NSString stringWithFormat:@"%@\n\n",textToSet];
    if (((NSArray*)self.currentItem[@"genres"]).count == 1) {
        textToSet = [NSString stringWithFormat:@"%@Genre: %@",textToSet,self.currentItem[@"genres"][0]];

    }
    else {
        textToSet = [NSString stringWithFormat:@"%@Genres:\n",textToSet];
        for (NSString *genre in self.currentItem[@"genres"]) {
            textToSet = [NSString stringWithFormat:@"%@    %@\n",textToSet,genre];
        }
    }
    self.overviewTextView.text = textToSet;
}

- (void) loadIMDB {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 25);
    [button setImage:[UIImage imageNamed:@"IMDB"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(showIMDB) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
}

- (void) showIMDB {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.imdb.com/title/%@",self.currentItem[@"imdb_id"]]]];
}
- (void) loadPoster {
    NSDictionary *imgs = self.currentItem[@"images"];
    NSString *imgString = imgs[@"poster"];
    imgString = [imgString substringToIndex:imgString.length-4];
    NSLog(@"%@",imgString);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@-300.jpg",imgString]];
    // note that this can be a web url or file url
    
    ImageRequest *request = [[ImageRequest alloc] initWithURL:url];
    
    UIImage *image = [request cachedResult];
    if (image) {
        self.posterView.image = image;
        self.posterView.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        [request startWithCompletion:^(UIImage *image, NSError *error) {
            if (image) {
                self.posterView.image = image;
                self.posterView.contentMode = UIViewContentModeScaleAspectFit;
            }
        }];
    }
}

- (IBAction)done:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)viewTrailer:(id)sender {
    LBYouTubePlayerViewController* controller = [[LBYouTubePlayerViewController alloc] initWithYouTubeURL:[NSURL URLWithString:self.currentItem[@"trailer"]] quality:LBYouTubeVideoQualityLarge];
        [self presentViewController:controller animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
