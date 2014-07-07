//
//  Note.m
//  THC
//
//  Created by David Bernthal on 7/6/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "Note.h"
#import <Parse/PFObject+Subclass.h>

@implementation Note

+ (NSString *)parseClassName {
    return @"Note";
}

@dynamic caseId;
@dynamic text;

@end
