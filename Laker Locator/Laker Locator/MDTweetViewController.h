//
//  MDTweetViewController.h
//  Laker Locator
//
//  Created by X Code User on 12/8/14.
//  Copyright (c) 2014 Michelle Dowling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDTweetViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tweetTableView;
@property (assign, nonatomic) int distance;
@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;

@end
