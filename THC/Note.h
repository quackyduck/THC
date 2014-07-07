//
//  Note.h
//  THC
//
//  Created by David Bernthal on 7/6/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <Parse/Parse.h>

@interface Note : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (retain) NSString *caseId;
@property (retain) NSString *text;

@end
