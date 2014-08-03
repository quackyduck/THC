//
//  ViolationPhoto.h
//  THC
//
//  Created by Hunaid Hussain on 8/2/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PhotoComment;

@interface ViolationPhoto : NSObject

@property (strong) UIImage *image;
@property (strong) NSArray *tags;
@property (strong) NSArray *comments;
@property (strong) NSDictionary *metaData;




+ (instancetype)photoWithProperties:(NSDictionary *)photoInfo;
- (id)initWithProperties:(NSDictionary *)photoInfo;

- (void)addComment:(PhotoComment *)comment;
@end
