//
//  MDLakerLocatorMapViewController.m
//  Laker Locator
//
//  Created by X Code User on 12/8/14.
//  Copyright (c) 2014 Michelle Dowling. All rights reserved.
//

#import "MDLakerLocatorMapViewController.h"
#import "MDTweetViewController.h"

@interface MDLakerLocatorMapViewController ()

@end

// Private variables for the distance, latitude, and longitude values
int distance;
double latitude;
double longitude;

@implementation MDLakerLocatorMapViewController

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

    // Initialize latitude and longitude
    latitude = 0.0;
    longitude = 0.0;
    
    // Set the text for the label to indicate how many miles are represented by the UISlider
    // Also saves the distance to the private variable
    [self updateDistanceLabel];
    
    // Register the view to capture long presses
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.mapView addGestureRecognizer:longPressGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"segueToTweetTable"])
    {
        // Set the TweetViewController's latitude, longitude, and distance to create the Tweet query
        MDTweetViewController *tweetViewController = [segue destinationViewController];
        tweetViewController.distance = distance;
        tweetViewController.latitude = latitude;
        tweetViewController.longitude = longitude;
    }
}

#pragma mark - LakerLocator UI Controls

// Update the label and the private variable with the current distance from the distanceSlider
-(void)updateDistanceLabel
{
    distance = (int)self.distanceSlider.value;
    self.distanceLabel.text = [NSString stringWithFormat:@"%d miles", distance];
}

// Make sure that the distance label changes whenever the UISlider's value changes
- (IBAction)distanceSliderValueChanged:(id)sender {
    [self updateDistanceLabel];
}

// Get the coordinates for the location on the map indicated by the user and place the pin there
-(void)handleLongPressGesture:(UIGestureRecognizer*)sender {
    // Get the latitude and longitude for where the user is pressing on the map
    CGPoint touchPoint = [sender locationInView:self.mapView];
    CLLocationCoordinate2D locationCoordinates = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    latitude = locationCoordinates.latitude;
    longitude = locationCoordinates.longitude;

    // Create a new pin with the new coordinates
    MKPointAnnotation *newPin = [[MKPointAnnotation alloc] init];
    newPin.coordinate = locationCoordinates;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotation:newPin];
    
    // Ensure that the search button is enabled
    self.searchButton.enabled = YES;
}

@end
