//
//  AsseptPicker.m
//  THC
//
//  Created by Hunaid Hussain on 7/14/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "AsseptPicker.h"

@interface AsseptPicker ()

@property (nonatomic, strong) NSMutableOrderedSet *selectedAssetsSet;

@end

@implementation AsseptPicker

- (id)init
{
    if ((self = [super init])) {
        self.assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return self;
}


- (NSMutableOrderedSet *)selectedAssetsSet
{
    if (!_selectedAssetsSet) {
        _selectedAssetsSet = [NSMutableOrderedSet orderedSet];
    }
    return _selectedAssetsSet;
}

- (NSArray *)selectedAssets
{
    return [[self.selectedAssetsSet array] copy];
}

- (void)changeSelectionState:(BOOL)selected forAsset:(ALAsset *)asset
{
    if (selected) {
        [self.selectedAssetsSet addObject:asset];
    } else {
        [self.selectedAssetsSet removeObject:asset];
    }
    
    // Update the observable count property.
    self.selectedCount = [self.selectedAssetsSet count];
}

@end
