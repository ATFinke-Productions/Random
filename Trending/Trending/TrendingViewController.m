//
//  TrendingViewController.m
//  Trending
//
//  Created by Andrew on 12/1/13.
//  Copyright (c) 2013 Andrew. All rights reserved.
//

#import "TrendingViewController.h"
#import "DetailViewController.h"

@interface TrendingViewController () {
    NSMutableArray *movieImages;
    NSMutableArray *movieData;
}

@end

@implementation TrendingViewController

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
    movieData = [NSMutableArray array];
    movieImages = [NSMutableArray array];
#error Need api key from http://trakt.tv/api-docs/authentication
    NSArray *trending = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://api.trakt.tv/movies/trending.json/YOURAPIKEY"]] options:kNilOptions error:nil];
    NSMutableArray *top100 = [NSMutableArray array];
    for (NSInteger count = 0; count < 101; count++) {
        [top100 addObject:trending[count]];
    }
    
    for (NSDictionary *dict in top100) {
        NSDictionary *imgs = dict[@"images"];
        NSString *imgString = imgs[@"poster"];
        imgString = [imgString substringToIndex:imgString.length-4];
        imgString = [NSString stringWithFormat:@"%@-138.jpg",imgString];
        
        [movieImages addObject:imgString];
        [movieData addObject:dict];
    }
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PosterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSURL *url = [NSURL URLWithString:movieImages[indexPath.row]];
    // note that this can be a web url or file url
    
    ImageRequest *request = [[ImageRequest alloc] initWithURL:url];
    
    UIImage *image = [request cachedResult];
    if (image) {
        cell.posterView.image = image;
        cell.posterView.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        [request startWithCompletion:^(UIImage *image, NSError *error) {
            if (image && [[collectionView indexPathsForVisibleItems] containsObject:indexPath]) {
                [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }
        }];
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return movieImages.count;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [[NSUserDefaults standardUserDefaults] setValue:movieData[indexPath.row] forKey:@"CurrentData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSegueWithIdentifier:@"showItemInfo" sender:self];
}

@end
