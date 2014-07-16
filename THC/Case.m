//
//  Case.m
//  THC
//
//  Created by David Bernthal on 7/5/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "Case.h"
#import <Parse/PFObject+Subclass.h>

@implementation Case

+ (NSString *)parseClassName {
    return @"Case";
}

@dynamic caseId;
@dynamic buildingId;
@dynamic name;
@dynamic address;
@dynamic unit;
@dynamic phoneNumber;
@dynamic email;
@dynamic languageSpoken;
@dynamic description;
@dynamic userId;
@dynamic photoIdList;
@dynamic status;

@end
