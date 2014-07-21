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
        self.violationDescriptionTextField.textColor = [UIColor lightGrayColor];
    }
    NSLog(@"violation edit end %@", self.violationDescriptionTextField.text);
}

- (void)textViewDidChange:(UITextView *)textView {
    

    
}
@end
