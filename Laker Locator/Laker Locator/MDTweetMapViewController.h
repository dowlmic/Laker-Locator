//
//  MDTweetMapViewController.h
//  Laker Locator
//
//  Created by X Code User on 12/8/14.
//  Copyright (c) 2014 Michelle Dowling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MDTweetMapViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *tweetMapView;
@property (strong, nonatomic) NSArray *tweetPins;

@end
