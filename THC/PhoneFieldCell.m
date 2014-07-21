//
//  PhoneFieldCell.m
//  THC
//
//  Created by Hunaid Hussain on 7/20/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "PhoneFieldCell.h"

@implementation PhoneFieldCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)editingFinished:(UITextField *)sender {
    [sender resignFirstResponder];
}

#pragma keyboard delegates
- (void)textViewDidChange:(UITextView *)textView {
    
    NSLog(@"text written so far %@", textView.text);
    
}


- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"textViewDidBeginEditing");
    //    self.nameTextField.textColor = [UIColor blackColor];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    NSLog(@"Full name: %@", self.phoneTextField.text);
    [self.phoneTextField resignFirstResponder];
}

@end
