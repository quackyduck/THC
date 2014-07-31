//
//  PhotoPickerCell.h
//  THC
//
//  Created by Christine Chao on 7/29/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FieldContent.h"

@interface PhotoPickerCell : UITableViewCell

@property (weak, nonatomic) id<FieldContent> delegate;

- (void)showMenu:(CGRect)frame onView:(UIView *)view forOrientation:(UIInterfaceOrientation) orientation;

- (void)getFieldValueFromform;

@end
