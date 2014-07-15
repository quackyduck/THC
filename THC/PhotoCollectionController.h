//
//  PhotoCollectionController.h
//  THC
//
//  Created by Hunaid Hussain on 7/14/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoPicker.h"

@class AsseptPicker;

@interface PhotoCollectionController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) AsseptPicker *assetPicker;
@property (nonatomic, strong) ALAssetsGroup *assetsGroup; // Model (a specific, filtered, group of assets).
@property (nonatomic, weak) id<PhotoPicker> delegate;


@end
