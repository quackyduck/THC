//
//  AssetWrapper.m
//  THC
//
//  Created by Hunaid Hussain on 7/14/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "AssetWrapper.h"

@implementation AssetWrapper

@synthesize asset = _asset;
@synthesize selected = _selected;

+ (AssetWrapper *)wrapperWithAsset:(ALAsset *)asset
{
    AssetWrapper *wrapper = [[AssetWrapper alloc] initWithAsset:asset];
    return wrapper;
}

- (id)initWithAsset:(ALAsset *)asset
{
    if ((self = [super init])) {
        _asset = asset;
    }
    return self;
}

@end
