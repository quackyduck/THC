//
//  CameraLauncher.m
//  THC
//
//  Created by David Bernthal on 7/10/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "CameraLauncher.h"
#import "CameraViewController.h"

@implementation CameraLauncher

- (void) launchCamera {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //picker.showsCameraControls = YES;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    CameraViewController *cvc = [[CameraViewController alloc] init];
    [cvc setImage:chosenImage];
    
    [self.navigationController pushViewController:cvc animated:YES];
    
}

@end
