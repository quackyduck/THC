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
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) NSMutableDictionary *buildingInfo;

@end

@implementation AggregateMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // init
        self.buildingInfo = [[NSMutableDictionary alloc] init];
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
        
    } else {
        NSLog(@"No user logged in.");
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"Building"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *buildings, NSError *error) {
        if (!error) {
            NSLog(@"Successfully retrieved %lu buildings.", (unsigned long)buildings.count);
            for (Building *building in buildings) {
                [self.mapView addAnnotation:building];
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
                NSLog(@"Successfully got %lu cases for building %@", (unsigned long)objects.count, building.buildingName);
//                [self.buildingInfo setValue:@(objects.count) forKey:building.objectId];
                annotationView.numberOfCases = objects.count;
                [annotationView setNeedsDisplay];
                
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
        
        
        
        annotationView.numberOfCases = [[self.buildingInfo valueForKey:building.objectId] intValue];
        [annotationView setNeedsDisplay];
        
    }
    else {
        annotationView.annotation = annotation;
    }
    
    annotationView.canShowCallout = YES;
    
    return annotationView;
}

@end
