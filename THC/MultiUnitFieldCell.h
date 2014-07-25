//
//  MultiUnitFieldCell.h
//  THC
//
//  Created by Hunaid Hussain on 7/21/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FieldContent.h"


@interface MultiUnitFieldCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *multiUnitField;
@property (weak, nonatomic) id<FieldContent> delegate;

- (void)showMenu:(CGRect)frame onView:(UIView *)view forOrientation:(UIInterfaceOrientation) orientation;

- (void)getFieldValueFromform;

@end
