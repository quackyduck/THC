//
//  ViolationSubmissionViewController.h
//  THC
//
//  Created by Hunaid Hussain on 7/4/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXForms.h"
#import "Case.h"
#import "AsseptPicker.h"
#import "PhotoPicker.h"
#import "ViolationForm.h"
#import "EBPhotoPagesDataSource.h"
#import "EBPhotoPagesDelegate.h"


@interface ViolationSubmissionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PhotoPicker, CLLocationManagerDelegate, EBPhotoPagesDataSource, EBPhotoPagesDelegate>

@property (nonatomic, strong) AsseptPicker *assetPicker;

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) FXFormController *formController;

-(void) setImageData:(NSData *) imageData;
-(void) setViolationDescription:(NSString *) description;
-(void) setCase:(Case *) myCase;
-(void) setPrefilledForm:(ViolationForm *) form;

@end
