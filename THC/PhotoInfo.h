//
//  PhotoInfo.h
//  THC
//
//  Created by Nicolas Melo on 7/6/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <Parse/Parse.h>

@interface PhotoInfo : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (retain) NSString *caseId;
@property (retain) NSString *caption;
@property (retain) PFFile *image;
@property (assign) UIImageOrientation orientation;

@end
