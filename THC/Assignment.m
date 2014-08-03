//
//  Assignment.m
//  THC
//
//  Created by David Bernthal on 7/26/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "Assignment.h"

@implementation Assignment

- (id)initWithUser:(PFUser *)user andCurrentCount:(NSNumber *)count {
    self = [super init];
    if (self) {
        self.userName = [NSString stringWithFormat:@"%@ %@", [user objectForKey:@"firstName"], [user objectForKey:@"lastName"]];
        self.userId = user.objectId;
    }
    return self;
}

@end
