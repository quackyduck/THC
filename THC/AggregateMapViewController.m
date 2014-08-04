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
#import "BuildingCalloutView.h"
#import "BuildingMapPin.h"
#import "BuildingPhoto.h"
#import "ViolationCountLabel.h"

@interface AggregateMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
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
    region.center.latitude = 37.777;
    region.center.longitude = -122.412752;
    
    region.span.longitudeDelta = 0.035f;
    region.span.latitudeDelta = 0.001f;
    [self.mapView setRegion:region animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    [self zoomInToTenderloin];
    
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

- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
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
    BuildingMapPin *annotationView = (BuildingMapPin *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    
    if (!annotationView) {
        
        annotationView = [[BuildingMapPin alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
        annotationView.canShowCallout = NO;
        
        Building *building = (Building *)annotation;
        [annotationView configureAnnotationWithBuilding:building];

    }
    else {
        annotationView.annotation = annotation;
    }
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    BuildingMapPin *annotationView = (BuildingMapPin *) view;
    
    Building *building = (Building *)view.annotation;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Case"];
    [query whereKey:@"buildingId" equalTo:building.objectId];
    [query whereKey:@"status" equalTo:@0];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully got %lu cases for building %@", (unsigned long)objects.count, building.buildingName);
            NSString *text = [NSString stringWithFormat:@"%lu", objects.count];
            UIImage *pin = [UIImage imageNamed:@"btn_map_pin_selected"];
            CGPoint point = CGPointMake(annotationView.bounds.origin.x + pin.size.width / 2.5f, annotationView.bounds.origin.y + 15);
            
            UIFont *font = [UIFont boldSystemFontOfSize:16];
            UIGraphicsBeginImageContextWithOptions(pin.size, NO, 0);
            [pin drawInRect:CGRectMake(0, 0, pin.size.width, pin.size.height)];
            CGRect rect = CGRectMake(point.x, point.y, pin.size.width, pin.size.height);
            [text drawInRect:rect withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor whiteColor]}];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            annotationView.image = newImage;
            annotationView.center = CGPointMake(annotationView.center.x, annotationView.center.y - 20);
            
            [annotationView setNeedsDisplay];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
    [mapView setRegion:[mapView convertRect:view.frame toRegionFromView:mapView] animated:YES];
    
    
    UINib *nib = [UINib nibWithNibName:@"BuildingCalloutView" bundle:nil];
    NSArray *nibs = [nib instantiateWithOwner:nil options:nil];
    
    BuildingCalloutView *buildingCallout = nibs[0];
    
    buildingCallout.frame = CGRectMake(7, 7, 292, 100);
    buildingCallout.alpha = 0;
    // buildingCallout.frame = CGRectMake(7, mapView.frame.size.height - 127, 292, 120);
    [buildingCallout.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [buildingCallout.layer setShadowOpacity:.35f];
    [buildingCallout.layer setShadowRadius:1];
    [buildingCallout.layer setShadowOffset:CGSizeMake(1, 1)];
    [buildingCallout.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [buildingCallout.layer setBorderWidth:0.5f];
    
//    Building *building = (Building *)view.annotation;
    
    buildingCallout.hotelNameLabel.text = building.buildingName;
    buildingCallout.hotelDescriptionLabel.text = building.streetAddress;
    buildingCallout.building = building;
    
    PFQuery *photoQuery = [BuildingPhoto query];
    [photoQuery whereKey:@"buildingId" equalTo:building.objectId];
    [photoQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0)
            {
                BuildingPhoto* photoObject = objects[0];
                PFFile *photo = photoObject.image;
                [photo getDataInBackgroundWithBlock:^(NSData *data, NSError *photoError) {
                    if (!photoError) {
                        NSData *imageData = data;
                        UIImage *image = [UIImage imageWithData:imageData];
                        
                        buildingCallout.imageView.image = image;
                        buildingCallout.imageView.layer.cornerRadius = 40;
                        buildingCallout.imageView.layer.masksToBounds = YES;
                        buildingCallout.imageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                        buildingCallout.imageView.layer.borderWidth = .5f;
                        buildingCallout.violationsCountLabel.layer.cornerRadius = 5;
                        buildingCallout.violationsCountLabel.textAlignment = NSTextAlignmentLeft;
                        buildingCallout.violationsCountLabel.backgroundColor = [UIColor colorWithRed: 1 green: 0.455f blue: 0.184f alpha: 1];
                        
                        PFQuery *caseQuery = [Case query];
                        [caseQuery whereKey:@"buildingId" equalTo:building.objectId];
                        [caseQuery whereKey:@"status" equalTo:@0];
                        [caseQuery findObjectsInBackgroundWithBlock:^(NSArray *caseObjects, NSError *queryError) {
                            if (!error) {
                                // The find succeeded.
                                NSLog(@"Successfully got %lu cases for building %@", (unsigned long)objects.count, building.buildingName);
                                
                                NSString *text;
                                if (caseObjects.count == 1) {
                                    text = [NSString stringWithFormat:@"1 Case"];
                                } else {
                                    text = [NSString stringWithFormat:@"%lu Cases", (unsigned long)caseObjects.count];
                                }
                                
                                
                                buildingCallout.violationsCountLabel.text = text;
                                [buildingCallout.violationsCountLabel sizeToFit];
                                
                            } else {
                                // Log details of the failure
                                NSLog(@"Error: %@ %@", queryError, [queryError userInfo]);
                            }
                        }];
                    }
                }];
                
            }
        }
    }];

    
    buildingCallout.center = CGPointMake(buildingCallout.center.x, buildingCallout.center.y + 30);
    [mapView addSubview:buildingCallout];
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        buildingCallout.alpha = 1;
        buildingCallout.center = CGPointMake(buildingCallout.center.x, buildingCallout.center.y - 30);
    } completion:^(BOOL finished) {
        self.currentCallout = buildingCallout;
    }];

}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.currentCallout.alpha = 0;
    } completion:^(BOOL finished) {
        [self.currentCallout removeFromSuperview];
    }];

//    [mapView removeAnnotation:view.annotation];
//    [mapView addAnnotation:view.annotation];
    
    BuildingMapPin *callout = (BuildingMapPin *)view;
    [callout configureAnnotationWithBuilding:(Building *)view.annotation];
    
    [self zoomInToTenderloin];
    
}

@end
