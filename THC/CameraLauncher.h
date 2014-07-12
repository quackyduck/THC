//
//  CameraLauncher.h
//  THC
//
//  Created by David Bernthal on 7/10/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CameraLauncher : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (void) launchCamera;

@end
