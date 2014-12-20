//
//  DetailViewController.h
//  Trending
//
//  Created by Andrew on 12/1/13.
//  Copyright (c) 2013 Andrew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBYouTube.h"

@interface DetailViewController : UIViewController

@property (nonatomic) NSDictionary *currentItem;

@property (weak, nonatomic) IBOutlet UIImageView *posterView;

@property (weak, nonatomic) IBOutlet UITextView *overviewTextView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;


- (IBAction)done:(id)sender;
- (IBAction)viewTrailer:(id)sender;
@end
