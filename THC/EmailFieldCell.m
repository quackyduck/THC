//
//  EmailFieldCell.m
//  THC
//
//  Created by Hunaid Hussain on 7/20/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "EmailFieldCell.h"

@implementation EmailFieldCell

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
    
    if ([self.delegate respondsToSelector:@selector(setValue:forField:)]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self.delegate setValue:self.emailTextField.text forField:@"email"];
        });
    }
    [sender resignFirstResponder];
}

- (void)getFieldValueFromform {
    if ([self.delegate respondsToSelector:@selector(getValueForField:)]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            self.emailTextField.text = [self.delegate getValueForField:@"email"];
        });
    }
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
    NSLog(@"Full name: %@", self.emailTextField.text);
    
    if ([self.delegate respondsToSelector:@selector(setValue:forField:)]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self.delegate setValue:textView.text forField:@"email"];
        });
    }
    [self.emailTextField resignFirstResponder];
}

@end
