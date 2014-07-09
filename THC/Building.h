//
//  Building.h
//  THC
//
//  Created by Nicolas Melo on 7/6/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <Parse/Parse.h>

@interface Building : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (retain) NSString *streetAddress;
@property (retain) NSString *city;
@property (retain) NSString *state;
@property (retain) NSString *zip;
@property (retain) NSString *buildingName;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@end
