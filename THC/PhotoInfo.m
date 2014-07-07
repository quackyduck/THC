//
//  PhotoInfo.m
//  THC
//
//  Created by Nicolas Melo on 7/6/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "PhotoInfo.h"
#import <Parse/PFObject+Subclass.h>

@implementation PhotoInfo

+ (NSString *)parseClassName {
    return @"Photo";
}

@dynamic caseId;
@dynamic caption;
@dynamic image;

@end
