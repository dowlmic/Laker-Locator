//
//  MDTweetViewController.m
//  Laker Locator
//
//  Created by X Code User on 12/8/14.
//  Copyright (c) 2014 Michelle Dowling. All rights reserved.
//

#import "MDTweetViewController.h"
#import "MDTweetTableViewCell.h"
#import "MDTweetMapViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface MDTweetViewController ()

@end

@implementation MDTweetViewController

// Private NSMutableDictionary for the Tweet JSON data
NSMutableDictionary *tweetData;

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
    
    // Initialize the TableView delegate and data source as well as initialize tweetData
    self.tweetTableView.delegate = self;
    self.tweetTableView.dataSource = self;
    tweetData = [[NSMutableDictionary alloc] init];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Get the Tweet stream
    [self setTwitterData];
}

-(void)setTwitterData
{
    // Access the AccountStore and request permission to use a Twitter account
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        if (granted) {
            
            // Get a Twitter account
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            ACAccount *twitterAccount = [accounts objectAtIndex:0];
            
            if (twitterAccount)
            {
                // Set up the request to the Twitter API
                NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json?"];
                NSString *geocodeString = [NSString stringWithFormat:@"%f,%f,%dmi", self.latitude, self.longitude, self.distance];
                NSDictionary *parameters = @{ @"screen_name" : twitterAccount.username,
                                              @"q" : @"gvsu",
                                              @"count" : @"50",
                                              @"geocode" : geocodeString};
                SLRequest *tweetRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:parameters];
                [tweetRequest setAccount:twitterAccount];
                
                // Send the request and save the data
                [tweetRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    if(urlResponse.statusCode == 200) {
                        NSError *parsingError = nil;
                        tweetData = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&parsingError];
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [self.tweetTableView reloadData];
                        });
                    }
                }];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

-(NSArray *)getTweetCoordinates
{
    // Initialize an NSMutableArray to store all the pin data for the map
    NSMutableArray *tweetPins = [[NSMutableArray alloc] init];

    for (NSDictionary *tweet in tweetData[@"statuses"])
    {
        // Set an NSDictionary with the current tweet information necessary to create a pin on the map
        NSArray *tweetCoordinates = tweet[@"geo"][@"coordinates"];
        NSDictionary *tweetPin = @{@"user" : tweet[@"user"][@"name"],
                                   @"tweet" : tweet[@"text"],
                                   @"latitude" : tweetCoordinates[0],
                                   @"longitude" : tweetCoordinates[1]};
        [tweetPins addObject:tweetPin];
    }
    return tweetPins;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segueToTweetMap"])
    {
        // Set the NSArray for the different Tweet pins in the TweetMapViewController
        MDTweetMapViewController *tweetMapViewController = [segue destinationViewController];
        tweetMapViewController.tweetPins = [self getTweetCoordinates];
    }
}

#pragma mark - Table View

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *tweets = tweetData[@"statuses"];
    return tweets.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDTweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tweetCell"];
    
    // Set the cell's text to the Tweet text
    NSDictionary *tweet = tweetData[@"statuses"][indexPath.row];
    cell.tweetTextView.text = tweet[@"text"];
    
    // Set the cell's image to the Tweet image
    NSString *urlString = tweet[@"user"][@"profile_image_url"];
    UIImage *tweetImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
    cell.imageView.image = tweetImage;
    
    return cell;
}

@end
