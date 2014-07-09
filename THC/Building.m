//
//  Building.m
//  THC
//
//  Created by Nicolas Melo on 7/6/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "Building.h"
#import <Parse/PFObject+Subclass.h>

@implementation Building

+ (NSString *)parseClassName {
    return @"Building";
}

@dynamic streetAddress;
@dynamic city;
@dynamic state;
@dynamic zip;
@dynamic buildingName;
@dynamic latitude;
@dynamic longitude;

- (NSString *)title {
    return self.buildingName;
}

- (NSString *)subtitle {
    return self.streetAddress;
}

- (CLLocationCoordinate2D) coordinate {
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    return coords;
}

@end
