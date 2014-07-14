//
//  AssetWrapper.h
//  THC
//
//  Created by Hunaid Hussain on 7/14/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface AssetWrapper : NSObject

@property (nonatomic, strong, readonly) ALAsset *asset;
@property (nonatomic, getter = isSelected) BOOL selected;

+ (AssetWrapper *)wrapperWithAsset:(ALAsset *)asset;

- (id)initWithAsset:(ALAsset *)asset;

@end
