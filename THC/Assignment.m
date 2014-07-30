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
        self.userName = user.username;
        self.userId = user.objectId;
//        self.count = count;
    }
    return self;
}

@end
