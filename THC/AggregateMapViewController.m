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
#import "SignupViewController.h"
#import "CameraLauncher.h"
#import "CaseTableViewController.h"
#import <Parse/Parse.h>
#import "Building.h"
#import "BuildingAnnotationView.h"

@interface AggregateMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation AggregateMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.loginButton = [[UIButton alloc] init];
        self.loginButton.hidden = NO;
        self.loginButton.enabled = YES;
    }
    return self;
}
- (IBAction)onLogin:(id)sender {
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    [self presentViewController:loginViewController animated:YES completion:nil];
    
}
- (IBAction)onSignup:(id)sender {
    SignupViewController *signupViewController = [[SignupViewController alloc] init];
    [self presentViewController:signupViewController animated:YES completion:nil];
}

-(void)zoomInToTenderloin
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
    self.mapView.delegate = self;
    [self zoomInToTenderloin];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"Logged in user %@", currentUser.username);
        self.signupButton.hidden = YES;
        [self.loginButton setTitle:@"Cases" forState:UIControlStateNormal];
        [self.loginButton removeTarget:self action:@selector(onLogin:) forControlEvents:UIControlEventTouchUpInside];
        [self.loginButton addTarget:self action:@selector(onCaseMenu:) forControlEvents:UIControlEventTouchUpInside];
        
    } else {
        NSLog(@"No user logged in.");
        [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
        [self.loginButton removeTarget:self action:@selector(onCaseMenu:) forControlEvents:UIControlEventTouchUpInside];
        [self.loginButton addTarget:self action:@selector(onLogin:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"Building"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *buildings, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %lu buildings.", (unsigned long)buildings.count);
            for (Building *buliding in buildings) {
                [self.mapView addAnnotation:buliding];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onNewReport:(id)sender {
    CameraLauncher *launcher = [[CameraLauncher alloc] init];
    [self.navigationController pushViewController:launcher animated:YES];
    [launcher launchCamera];
}


- (void)onCaseMenu:(id)sender {
    NSLog(@"Load case menu.");
    CaseTableViewController *caseViewController = [[CaseTableViewController alloc] init];
    [self.navigationController pushViewController:caseViewController animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    [self.searchBar resignFirstResponder];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    static NSString* AnnotationIdentifier = @"Annotation";
    BuildingAnnotationView *annotationView = (BuildingAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    if (!annotationView) {
        annotationView = [[BuildingAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
        annotationView.frame = CGRectMake(0, 0, 35, 35);
        annotationView.backgroundColor = [UIColor clearColor];
        
        Building *building = (Building *)annotation;
        
        
        PFQuery *query = [PFQuery queryWithClassName:@"Case"];
        [query whereKey:@"buildingId" equalTo:building.objectId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                NSLog(@"Successfully got %d cases for building %@", objects.count, building.buildingName);
                // Do something with the found objects
                annotationView.numberOfCases = objects.count;
                [annotationView setNeedsDisplay];
                
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
        
    }
    else {
        annotationView.annotation = annotation;
    }
    
    annotationView.canShowCallout = YES;
    
    return annotationView;
}

@end
