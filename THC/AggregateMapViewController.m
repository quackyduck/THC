//
//  AggregateMapViewController.m
//  THC
//
//  Created by Nicolas Melo on 7/3/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "AggregateMapViewController.h"
#import <MapKit/MapKit.h>
#import "LoginViewController.h"

@interface AggregateMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
//@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation AggregateMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.locationManager = [[CLLocationManager alloc] init];
//        self.locationManager.delegate = self;
//        [self.locationManager setDistanceFilter:CLLocationDistanceMax];
//        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    }
    return self;
}
- (IBAction)onLogin:(id)sender {
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    [self presentViewController:loginViewController animated:YES completion:nil];
    
}
- (IBAction)onSignup:(id)sender {
}

-(void)zoomInToMyLocation
{
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = 37.785134;
    region.center.longitude = -122.412752;
    
    region.span.longitudeDelta = 0.03f;
    region.span.latitudeDelta = 0.03f;
    [self.mapView setRegion:region animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self zoomInToMyLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
