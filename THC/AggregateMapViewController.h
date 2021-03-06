//
//  AggregateMapViewController.h
//  THC
//
//  Created by Nicolas Melo on 7/3/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapkit/MapKit.h>

@class BuildingCalloutView;
@interface AggregateMapViewController : UIViewController <UITextFieldDelegate, MKMapViewDelegate>
@property (strong, nonatomic) BuildingCalloutView *currentCallout;

@end
