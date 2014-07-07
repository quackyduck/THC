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

@end
