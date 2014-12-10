//
//  MDTweetMapViewController.m
//  Laker Locator
//
//  Created by X Code User on 12/8/14.
//  Copyright (c) 2014 Michelle Dowling. All rights reserved.
//

#import "MDTweetMapViewController.h"

@interface MDTweetMapViewController ()

@end

@implementation MDTweetMapViewController

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
    self.tweetMapView.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Set the information for the pins
    for (NSDictionary *pinDetails in self.tweetPins)
    {
        MKPointAnnotation *newPin = [[MKPointAnnotation alloc] init];
        
        // Set the pin coordinates
        NSString *latitude = pinDetails[@"latitude"];
        NSString *longitude = pinDetails[@"longitude"];
        CLLocationCoordinate2D pinCoordinates = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
        newPin.coordinate = pinCoordinates;
        
        // Set the pin title and subtitle
        newPin.title = pinDetails[@"user"];
        newPin.subtitle = pinDetails[@"tweet"];
        
        // Add the pin to the map
        [self.tweetMapView addAnnotation:newPin];
    }
    [self.tweetMapView showAnnotations:self.tweetMapView.annotations animated:YES];
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

#pragma mark MKMapViewDelegate methods

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    // Set annotation view
    MKPinAnnotationView *pinView = nil;
    if([annotation isKindOfClass:[MKPointAnnotation class]]) {
        pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinView"];
        if(!pinView) {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinView"];
            
            // Ensure pin title and subtitle can show
            pinView.canShowCallout = YES;
            
            // Set annotation image to a scaled version of twitterPin.png
            UIImage *tweetImage = [UIImage imageNamed:@"twitterPin"];
            UIImage *scaledImage = [UIImage imageWithCGImage:[tweetImage CGImage] scale:10 orientation:tweetImage.imageOrientation];
            pinView.image = scaledImage;
            
        } else {
            pinView.annotation = annotation;
        }
    }
    return pinView;
}

@end
