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

@interface ViolationSubmissionViewController : UIViewController <FXFormControllerDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) FXFormController *formController;

-(void) setImageData:(NSData *) imageData;
-(void) setViolationDescription:(NSString *) description;
-(void) setCase:(Case *) myCase;

@end
