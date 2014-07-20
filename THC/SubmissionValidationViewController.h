//
//  SubmissionValidationViewController.h
//  THC
//
//  Created by David Bernthal on 7/19/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Case.h"

@interface SubmissionValidationViewController : UIViewController

- (id)initWithCase:(Case *)myCase withTopPhoto:(UIImage *)firstPhoto;

@end
