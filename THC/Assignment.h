//
//  Assignment.h
//  THC
//
//  Created by David Bernthal on 7/26/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Assignment : NSObject

@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) NSString* count;

- (id)initWithUser:(PFUser *)user andCurrentCount:(NSNumber*)count;

@end
