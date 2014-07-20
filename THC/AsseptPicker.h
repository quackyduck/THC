//
//  AsseptPicker.h
//  THC
//
//  Created by Hunaid Hussain on 7/14/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface AsseptPicker : NSObject

@property (nonatomic, strong)     ALAssetsLibrary   *assetsLibrary;
@property (nonatomic, readonly)   NSArray           *selectedAssets;
@property (nonatomic, readwrite)  NSUInteger        selectedCount;
@property (nonatomic, readwrite)  NSUInteger         selectionLimit;
//@property (nonatomic, readwrite)  AssetPickingState state;

- (void)changeSelectionState:(BOOL)selected forAsset:(ALAsset *)asset;
-(void) clearSelection;

@end
