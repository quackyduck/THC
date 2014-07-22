//
//  NameFieldCell.m
//  THC
//
//  Created by Hunaid Hussain on 7/20/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "NameFieldCell.h"

@implementation NameFieldCell

- (void)awakeFromNib
{
    self.nameTextField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)editingFinished:(id)sender {
    
    NSLog(@"Full name: %@", self.nameTextField.text);
    if ([self.delegate respondsToSelector:@selector(setValue:forField:)]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self.delegate setValue:self.nameTextField.text forField:@"name"];
        });
    }

    [sender resignFirstResponder];
}

- (void)getFieldValueFromform {
    if ([self.delegate respondsToSelector:@selector(getValueForField:)]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            self.nameTextField.text = [self.delegate getValueForField:@"name"];
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
    NSLog(@"Full name: %@", self.nameTextField.text);
    
    if ([self.delegate respondsToSelector:@selector(setValue:forField:)]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self.delegate setValue:textView.text forField:@"name"];
        });
    }

    [self.nameTextField resignFirstResponder];
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    
//    return YES;
//}

@end
