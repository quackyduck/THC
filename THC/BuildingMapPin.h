//
//  BuildingMapPin.h
//  THC
//
//  Created by Nicolas Melo on 7/23/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <MapKit/MapKit.h>

@class BuildingCalloutView;
@class Building;

@interface BuildingMapPin : MKAnnotationView

- (void)configureAnnotationWithBuilding:(Building *)building;
@property (strong, nonatomic) BuildingCalloutView *calloutView;

@end
