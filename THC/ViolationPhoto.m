//
//  ViolationPhoto.m
//  THC
//
//  Created by Hunaid Hussain on 8/2/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "ViolationPhoto.h"
#import "PhotoComment.h"

@implementation ViolationPhoto

+ (instancetype)photoWithProperties:(NSDictionary *)photoInfo
{
    return [[ViolationPhoto alloc] initWithProperties:photoInfo];
}

- (id)initWithProperties:(NSDictionary *)photoInfo;
{
    self = [super init];
    if (self) {
        
        [self setImage:photoInfo[@"image"]];
        [self setTags:photoInfo[@"tags"]];
        [self setComments:photoInfo[@"comments"]];
        [self setMetaData:photoInfo[@"metaData"]];
        
    }
    return self;
}


- (void)addComment:(PhotoComment *)comment
{
    NSMutableArray *mutableComments = [NSMutableArray arrayWithArray:self.comments];
    if(!mutableComments){
        mutableComments = [NSMutableArray array];
    }
    [mutableComments addObject:comment];
    
    [self setComments:[NSArray arrayWithArray:mutableComments]];
}

@end
