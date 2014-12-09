//
//  MDLakerLocatorMapViewController.m
//  Laker Locator
//
//  Created by X Code User on 12/8/14.
//  Copyright (c) 2014 Michelle Dowling. All rights reserved.
//

#import "MDLakerLocatorMapViewController.h"

@interface MDLakerLocatorMapViewController ()

@end

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
    [self updateDistanceLabel];
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.mapView addGestureRecognizer:longPressGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - LakerLocator UI Controls

// Update the label with the current distance from the distanceSlider
-(void)updateDistanceLabel
{
    self.distanceLabel.text = [NSString stringWithFormat:@"%d miles", (int)self.distanceSlider.value];
}

- (IBAction)distanceSliderValueChanged:(id)sender {
    [self updateDistanceLabel];
}

-(void)handleLongPressGesture:(UIGestureRecognizer*)sender {
    // This is important if you only want to receive one tap and hold event
    CGPoint touchPoint = [sender locationInView:self.mapView];
    CLLocationCoordinate2D locationCoordinates = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];

    MKPointAnnotation *newPin = [[MKPointAnnotation alloc] init];
    newPin.coordinate = locationCoordinates;
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotation:newPin];
}

@end
