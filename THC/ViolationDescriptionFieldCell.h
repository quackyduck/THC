//
//  ViolationDescriptionFieldCell.h
//  THC
//
//  Created by Hunaid Hussain on 7/20/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FieldContent.h"

@interface ViolationDescriptionFieldCell : UITableViewCell <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *violationDescriptionTextField;
@property (weak, nonatomic) id<FieldContent> delegate;

- (void)getFieldValueFromform;

@end
