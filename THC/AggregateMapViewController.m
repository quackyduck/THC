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
    region.center.latitude = 37.78;
    region.center.longitude = -122.412752;
    
    region.span.longitudeDelta = 0.05f;
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
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    if (!annotationView) {
        
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
        Building *building = (Building *)annotation;
        
        PFQuery *query = [PFQuery queryWithClassName:@"Case"];
        [query whereKey:@"buildingId" equalTo:building.objectId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                NSLog(@"Successfully got %lu cases for building %@", (unsigned long)objects.count, building.buildingName);
                NSString *text = [NSString stringWithFormat:@"%d", objects.count];
                UIImage *pin = [UIImage imageNamed:@"btn_map_pin_normal"];
                CGPoint point = CGPointMake(annotationView.bounds.origin.x + pin.size.width / 2.5f, annotationView.bounds.origin.y + pin.size.height / 3);
                
                UIFont *font = [UIFont systemFontOfSize:14];
                UIGraphicsBeginImageContextWithOptions(pin.size, NO, 0);
                [pin drawInRect:CGRectMake(0, 0, pin.size.width, pin.size.height)];
                CGRect rect = CGRectMake(point.x, point.y, pin.size.width, pin.size.height);
                [text drawInRect:rect withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor whiteColor]}];
                UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                
                
                annotationView.image = newImage;
                [annotationView setNeedsDisplay];

                
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
//
//        
//        
//        annotationView.numberOfCases = [[self.buildingInfo valueForKey:building.objectId] intValue];
        
        
        
    }
    else {
        annotationView.annotation = annotation;
    }
    
    annotationView.canShowCallout = YES;
    
    return annotationView;
}

-(UIImage *)addText:(UIImage *)img text:(NSString *)text1{
    int w = img.size.width;
    int h = img.size.height;
    //lon = h - lon;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1);
	
    char* text	= (char *)[text1 cStringUsingEncoding:NSASCIIStringEncoding];// "05/05/09";
    CGContextSelectFont(context, "Arial", 18, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetRGBFillColor(context, 255, 255, 255, 1);
	
    
    //rotate text
    CGContextSetTextMatrix(context, CGAffineTransformMakeRotation( -M_PI/4 ));
	
    CGContextShowTextAtPoint(context, 4, 52, text, strlen(text));
	
	
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
	
    return [UIImage imageWithCGImage:imageMasked];
}

@end
