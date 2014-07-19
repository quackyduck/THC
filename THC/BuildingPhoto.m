//
//  BuildingPhoto.m
//  THC
//
//  Created by David Bernthal on 7/18/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "BuildingPhoto.h"
#import <Parse/PFObject+Subclass.h>

@implementation BuildingPhoto

+ (NSString *)parseClassName {
    return @"BuildingPhoto";
}

@dynamic buildingId;
@dynamic image;

@end
