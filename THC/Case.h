//
//  Case.h
//  THC
//
//  Created by David Bernthal on 7/5/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <Parse/Parse.h>

typedef enum {
    caseOpen,
    caseClosed
} status;

@interface Case : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (retain) NSString *caseId;
@property (retain) NSString *buildingId;
@property (retain) NSString *name;
@property (retain) NSString *address;
@property (retain) NSString *unit;
@property (retain) NSString *phoneNumber;
@property (retain) NSString *email;
@property (retain) NSString *languageSpoken;
//@property (retain) NSString *description;
@property (retain) NSString *violationDetails;
@property (retain) NSString *violationType;
@property (retain) NSString *userId;
@property (assign) BOOL     multiUnitPetition;
@property (retain) NSArray  *photoIdList;
@property status status;

@end
