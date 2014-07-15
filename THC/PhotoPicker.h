//
//  PhotoPicker.h
//  THC
//
//  Created by Hunaid Hussain on 7/14/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PhotoPicker <NSObject>

- (void) finishedPhotoPicker:(UIViewController *) picker withCameraTakenImages:(NSArray *) selectedImages;
- (void) finishedPhotoPicker:(UIViewController *) picker withUserSelectedAssets:(NSArray *) selectedAssets;

@optional
- (void) swapToCameraFromPhotoPicker:(UIViewController *)picker;
- (void) cancelPhotoPicker:(UIViewController *) picker;

@end
