//
//  ViolationDescriptionFieldCell.m
//  THC
//
//  Created by Hunaid Hussain on 7/20/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "ViolationDescriptionFieldCell.h"

@implementation ViolationDescriptionFieldCell

- (void)awakeFromNib
{
    self.violationDescriptionTextField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)getFieldValueFromform {
    if ([self.delegate respondsToSelector:@selector(getValueForField:)]) {
        
            NSString *value = [self.delegate getValueForField:@"violationDescription"];
            if (value != nil && ![value isEqualToString:@""]) {
                self.violationDescriptionTextField.text = value;
            }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([self.violationDescriptionTextField.text isEqualToString:@"Describe the Violation"]) {
        self.violationDescriptionTextField.text = @"";
        self.violationDescriptionTextField.textColor = [UIColor blackColor];
    }
    NSLog(@"violation text edit begin at %f", self.frame.origin.y);
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    
    self.violationDescriptionTextField.userInteractionEnabled = NO;
    if ([self.violationDescriptionTextField.text isEqualToString:@""]) {
        self.violationDescriptionTextField.text = @"Describe the Violation";
        self.violationDescriptionTextField.textColor = [UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:205.0/255.0 alpha:1];
    } else {
        if ([self.delegate respondsToSelector:@selector(setValue:forField:)]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [self.delegate setValue:self.violationDescriptionTextField.text forField:@"violationDescription"];
            });
        }
    }
    NSLog(@"violation edit end %@", self.violationDescriptionTextField.text);
}

- (void)textViewDidChange:(UITextView *)textView {
    

    
}
@end
