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

@end
