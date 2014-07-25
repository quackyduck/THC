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
    
    if ([self.delegate respondsToSelector:@selector(setValue:forField:)]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self.delegate setValue:self.phoneTextField.text forField:@"phone"];
        });
    }
    [sender resignFirstResponder];
}

- (void)getFieldValueFromform {
    if ([self.delegate respondsToSelector:@selector(getValueForField:)]) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            NSString *value = [self.delegate getValueForField:@"phone"];
            if (value != nil && ![value isEqualToString:@""]) {
                self.phoneTextField.text = value;
            }
//        });
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
    NSLog(@"Full name: %@", self.phoneTextField.text);
    
    if ([self.delegate respondsToSelector:@selector(setValue:forField:)]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self.delegate setValue:textView.text forField:@"phone"];
        });
    }
    
    [self.phoneTextField resignFirstResponder];
}

@end
