//
//  BuildingPhoto.h
//  THC
//
//  Created by David Bernthal on 7/18/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <Parse/Parse.h>

@interface BuildingPhoto : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property (retain) NSString *buildingId;
@property (retain) PFFile *image;

@end
