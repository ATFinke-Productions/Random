//
//  TALogoViewController.m
//  Top Media
//
//  Created by Andrew on 9/7/13.
//  Copyright (c) 2013 ATFinke Productions Incorperated. All rights reserved.
//

#import "TALogoViewController.h"


@interface TALogoViewController ()
{
    NSMutableArray *currentConnections;
    int numberOfImages;
    BOOL hasGoneThrough;

}

@end

@implementation TALogoViewController

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
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if (![self hasFourInchDisplay]) {
        self.logoView.image = [UIImage imageNamed:@"splash-4"];
    }
}

- (BOOL)hasFourInchDisplay {
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568.0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    [self startLoad];
}

- (void) startLoad {
    currentConnections = [NSMutableArray array];
    
    
    NSArray *rssFeeds = @[@"https://itunes.apple.com/us/rss/topaudiobooks/limit=25/xml",@"https://itunes.apple.com/us/rss/topmovies/limit=25/xml",@"https://itunes.apple.com/us/rss/topalbums/limit=25/xml",@"https://itunes.apple.com/us/rss/topsongs/limit=25/xml",@"https://itunes.apple.com/us/rss/toppodcasts/limit=25/xml",@"https://itunes.apple.com/us/rss/toptvepisodes/limit=25/xml",@"https://itunes.apple.com/us/rss/toptvseasons/limit=25/xml"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSMutableArray *urlsOfImages = [NSMutableArray array];
    
    
    for (NSString *rssFeedURL in rssFeeds) {
        NSURL * url = [NSURL URLWithString:rssFeedURL];
        
        NSString *string = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
        
        NSArray * array = [string componentsSeparatedByString:@"<entry>"];
        
        for (NSString *string in array) {
            NSRange range = [string rangeOfString:@"<im:image height=\"170\">"];
            if (range.location != NSNotFound) {
                NSString *substring = [[string substringFromIndex:NSMaxRange(range)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                range = [substring rangeOfString:@"</im:image>"];
                substring = [[substring substringToIndex:NSMaxRange(range)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                substring = [substring substringToIndex:substring.length-11];
                [urlsOfImages addObject:[NSURL URLWithString:substring]];
                [urlsOfImages addObject:[NSURL URLWithString:substring]];
            }
            range = [string rangeOfString:@"<im:image height=\"100\">"];
            if (range.location != NSNotFound) {
                NSString *substring = [[string substringFromIndex:NSMaxRange(range)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                range = [substring rangeOfString:@"</im:image>"];
                substring = [[substring substringToIndex:NSMaxRange(range)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                substring = [substring substringToIndex:substring.length-11];
                [urlsOfImages addObject:[NSURL URLWithString:substring]];
                [urlsOfImages addObject:[NSURL URLWithString:substring]];
            }
        }
    }
    
    numberOfImages = urlsOfImages.count;
    
    NSUInteger count = urlsOfImages.count;
    for (NSUInteger i = 0; i < count; ++i) {
        NSInteger nElements = count - i;
        NSInteger n = (arc4random() % nElements) + i;
        [urlsOfImages exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    for (NSURL *mediaURL in urlsOfImages) {
        NSURLRequest *request = [NSURLRequest requestWithURL:mediaURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10];
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
        [currentConnections addObject:connection];
    }
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    [currentConnections removeObject:connection];
    [self checkForEnd];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [currentConnections removeObject:connection];
    [self checkForEnd];
}

- (void) checkForEnd {
    if (currentConnections.count == 0) {
        if (!hasGoneThrough) {
            for (NSURLConnection *connection in currentConnections) {
                [connection cancel];
            }
            [self performSegueWithIdentifier:@"doneLoading" sender:self];
            hasGoneThrough = YES;
        }
    }
    else {
        double toDo = (double)numberOfImages;
        double completed = (double)(numberOfImages - currentConnections.count);
        self.progressView.progress = completed/toDo;
    }
}

@end
