//
//  TAMediaViewController.m
//  Top Apps
//
//  Created by Andrew on 9/7/13.
//  Copyright (c) 2013 ATFinke Productions Incorperated. All rights reserved.
//

#import "TAMediaViewController.h"
#import "TACollectionViewCell.h"

@interface TAMediaViewController () {
    NSMutableArray *mediaIcons;
    NSMutableArray *urls;
    NSMutableData * responseData;
    NSMutableArray *currentConnections;
    NSString *dataURLString;
    NSString *imageHeightString;
    CGSize mediaItemSize;
    BOOL shouldUpdateSize;
    int numberOfItems;
}

@end

@implementation TAMediaViewController

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
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    numberOfItems = 25;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.optionsController = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Songs", @"Albums", nil]];
    self.optionsController.frame = CGRectMake(0, 0, 160, self.optionsController.frame.size.height);
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.optionsController];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 40)];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.titleLabel];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    self.optionsController.selectedSegmentIndex = 0;
    
    self.tabBar.selectedItem = self.tabBar.items[0];
    self.tabBar.delegate = self;
    
    [self.optionsController addTarget:self action:@selector(newMediaSeleted) forControlEvents:UIControlEventValueChanged];
    
    currentConnections = [NSMutableArray array];
    responseData = [NSMutableData data];
    mediaIcons = [NSMutableArray array];
    
    mediaItemSize = CGSizeMake(85, 85);
    [self newMediaSeleted];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    [self newMediaSeleted];
}

- (void)newMediaSeleted {
    
    for (NSURLConnection *connection in currentConnections) {
        [connection cancel];
    }
    
    for (UILabel *label in self.view.subviews) {
        if (label.tag == 10) {
            label.hidden = YES;
        }
    }
    
    if ([self.tabBar.selectedItem isEqual:self.tabBar.items[0]]) {
        self.optionsController.hidden = NO;
        [self.optionsController setTitle:@"Songs" forSegmentAtIndex:0];
        [self.optionsController setTitle:@"Albums" forSegmentAtIndex:1];
        
        
        if (self.optionsController.selectedSegmentIndex == 0) {
            dataURLString = [NSString stringWithFormat:@"https://itunes.apple.com/us/rss/topsongs/limit=%i/xml",numberOfItems];
            imageHeightString = @"<im:image height=\"170\">";
            if (mediaItemSize.height != 85 || mediaItemSize.width != 85) {
                mediaItemSize = CGSizeMake(85, 85);
                shouldUpdateSize = YES;
            }
            self.titleLabel.text = @"  Top Songs";
        }
        else {
            dataURLString = [NSString stringWithFormat:@"https://itunes.apple.com/us/rss/topalbums/limit=%i/xml",numberOfItems];
            imageHeightString = @"<im:image height=\"170\">";
            if (mediaItemSize.height != 85 || mediaItemSize.width != 85) {
                mediaItemSize = CGSizeMake(85, 85);
                shouldUpdateSize = YES;
            }
            self.titleLabel.text = @"  Top Albums";
        }
        [self reloadData];
    }
    else if ([self.tabBar.selectedItem isEqual:self.tabBar.items[1]]) {
        self.optionsController.hidden = YES;
        [self.optionsController removeSegmentAtIndex:2 animated:NO];
        dataURLString = [NSString stringWithFormat:@"https://itunes.apple.com/us/rss/topMovies/limit=%i/xml",numberOfItems];
        imageHeightString = @"<im:image height=\"170\">";
        mediaItemSize = CGSizeMake(60, 85);
        if (mediaItemSize.height != 85 || mediaItemSize.width != 60) {
            mediaItemSize = CGSizeMake(60, 85);
            shouldUpdateSize = YES;
        }
        self.titleLabel.text = @"  Top Movies";
        [self reloadData];
    }
    else if ([self.tabBar.selectedItem isEqual:self.tabBar.items[2]]) {
        self.optionsController.hidden = NO;
        [self.optionsController setTitle:@"Episodes" forSegmentAtIndex:0];
        [self.optionsController setTitle:@"Seasons" forSegmentAtIndex:1];
        [self.optionsController removeSegmentAtIndex:2 animated:NO];
        if (self.optionsController.selectedSegmentIndex == 0) {
            dataURLString = [NSString stringWithFormat:@"https://itunes.apple.com/us/rss/topTvEpisodes/limit=%i/xml",numberOfItems];
            imageHeightString = @"<im:image height=\"100\">";
            if (mediaItemSize.height != 50 || mediaItemSize.width != 50) {
                mediaItemSize = CGSizeMake(50, 50);
                shouldUpdateSize = YES;
            }
            self.titleLabel.text = @"  Top Episodes";
        }
        else {
            dataURLString = [NSString stringWithFormat:@"https://itunes.apple.com/us/rss/topTvSeasons/limit=%i/xml",numberOfItems];
            imageHeightString = @"<im:image height=\"170\">";
            if (mediaItemSize.height != 85 || mediaItemSize.width != 85) {
                mediaItemSize = CGSizeMake(85, 85);
                shouldUpdateSize = YES;
            }
            self.titleLabel.text = @"  Top Seasons";
        }
        [self reloadData];
    }
    else if ([self.tabBar.selectedItem isEqual:self.tabBar.items[3]]) {
        self.optionsController.hidden = YES;
        dataURLString = [NSString stringWithFormat:@"https://itunes.apple.com/us/rss/toppodcasts/limit=%i/explicit=true/xml",numberOfItems];
        imageHeightString = @"<im:image height=\"170\">";
        if (mediaItemSize.height != 85 || mediaItemSize.width != 85) {
            mediaItemSize = CGSizeMake(85, 85);
            shouldUpdateSize = YES;
        }
        self.titleLabel.text = @"  Top Podcasts";
        [self reloadData];
    }
    else if ([self.tabBar.selectedItem isEqual:self.tabBar.items[4]]) {
        self.optionsController.hidden = YES;
        dataURLString = [NSString stringWithFormat:@"https://itunes.apple.com/us/rss/topaudiobooks/limit=%i/xml",numberOfItems];
        imageHeightString = @"<im:image height=\"170\">";
        if (mediaItemSize.height != 85 || mediaItemSize.width != 85) {
            mediaItemSize = CGSizeMake(85, 85);
            shouldUpdateSize = YES;
        }
        self.titleLabel.text = @"  Top Audiobooks";
        [self reloadData];
    }
    else if ([self.tabBar.selectedItem isEqual:self.tabBar.items[5]]) {
        self.optionsController.hidden = YES;
        [mediaIcons removeAllObjects];
        [self.optionsController removeSegmentAtIndex:2 animated:NO];
        [self.collectionView reloadData];
        self.titleLabel.text = @"  More";
        
        for (UILabel *label in self.view.subviews) {
            if (label.tag == 10) {
                label.hidden = NO;
            }
        }
        
    }
    else if ([self.tabBar.selectedItem isEqual:self.tabBar.items[6]]) {
        self.optionsController.hidden = YES;
        dataURLString = [NSString stringWithFormat:@"https://itunes.apple.com/us/rss/topitunesucollections/limit=%i/xml",numberOfItems];
        imageHeightString = @"<im:image height=\"170\">";
        if (mediaItemSize.height != 85 || mediaItemSize.width != 85) {
            mediaItemSize = CGSizeMake(85, 85);
            shouldUpdateSize = YES;
        }
        self.titleLabel.text = @"  Top iTunes U Collections";
        [self reloadData];
    }

    
    
}

- (void) reloadData {
    
    [mediaIcons removeAllObjects];
    
    NSURL * url = [NSURL URLWithString:dataURLString];
    
    NSString *string = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
    
    NSArray * array = [string componentsSeparatedByString:@"<entry>"];
    urls = [NSMutableArray array];
    [urls removeAllObjects];
    [currentConnections removeAllObjects];
    for (NSString *string in array) {
        NSRange range = [string rangeOfString:imageHeightString];
        if (range.location != NSNotFound) {
            NSString *substring = [[string substringFromIndex:NSMaxRange(range)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            range = [substring rangeOfString:@"</im:image>"];
            substring = [[substring substringToIndex:NSMaxRange(range)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            substring = [substring substringToIndex:substring.length-11];
            [urls addObject:[NSURL URLWithString:substring]];
        }
    }
    
   /* NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    */
    for (NSURL *mediaURL in urls) {
        
        /*NSString *urlString = [NSString stringWithFormat:@"%@",mediaURL];
                               
        if (urlString.length < 80) {
            urlString = [urlString substringToIndex:50];
        }
        else if (urlString.length < 110) {
            urlString = [urlString substringToIndex:75];
        }
        else {
            urlString = [urlString substringToIndex:105];
        }
        
        urlString = [urlString stringByReplacingOccurrencesOfString:@"/" withString:@""];
        urlString = [urlString stringByReplacingOccurrencesOfString:@"." withString:@""];
        urlString = [urlString stringByReplacingOccurrencesOfString:@":" withString:@""];

        NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",urlString]];
        
        if (![fileManager fileExistsAtPath:path]) {*/
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            NSURLRequest *request = [NSURLRequest requestWithURL:mediaURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10];
            NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
            [currentConnections addObject:connection];
       /* }
        else {
            UIImage* image = [UIImage imageWithContentsOfFile:path];
            if (image) {
                [mediaIcons addObject:image];
            }
            else {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                NSURLRequest *request = [NSURLRequest requestWithURL:mediaURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
                NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
                [currentConnections addObject:connection];
            }
            
        }*/
        
    }
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [responseData setLength:0];
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [responseData appendData:data];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    
    [currentConnections removeObject:connection];
    
    if (currentConnections.count == 0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
    UIImage *image = [UIImage imageWithData:responseData];
    
    if ([self dataIsValidJPEG:responseData]) {
        [mediaIcons addObject:image];
    }
    
    else {
        [mediaIcons addObject:[UIImage new]];
    }
    
    
    [self.collectionView reloadData];
    
    if (shouldUpdateSize) {
        shouldUpdateSize = NO;
        [self.collectionView performBatchUpdates:nil completion:nil];
    }
    
    /*NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *urlString = [NSString stringWithFormat:@"%@",connection.originalRequest.URL];
    
    if (urlString.length < 80) {
        urlString = [urlString substringToIndex:50];
    }
    else if (urlString.length < 110) {
        urlString = [urlString substringToIndex:75];
    }
    else {
        urlString = [urlString substringToIndex:105];
    }
    
    urlString = [urlString stringByReplacingOccurrencesOfString:@"/" withString:@""];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"." withString:@""];
    urlString = [urlString stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",urlString]];
    NSData* data = UIImagePNGRepresentation(image);
    [data writeToFile:path atomically:YES];*/
}
    
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error");
    [currentConnections removeObject:connection];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return mediaItemSize;
}

-(BOOL)dataIsValidJPEG:(NSData *)data
{
    if (!data || data.length < 2) return NO;
    
    NSInteger totalBytes = data.length;
    const char *bytes = (const char*)[data bytes];
    
    return (bytes[0] == (char)0xff &&
            bytes[1] == (char)0xd8 &&
            bytes[totalBytes-2] == (char)0xff &&
            bytes[totalBytes-1] == (char)0xd9);
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TACollectionViewCell *iconCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UIImage *image = mediaIcons[indexPath.row];
    
    
    iconCell.iconView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    
    if (![image isEqual:[UIImage new]]) {
        iconCell.iconView.image = image;
    }
    
    
    
    return iconCell;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return mediaIcons.count;
}

@end
