//
//  PhotoPickerCell.m
//  THC
//
//  Created by Christine Chao on 7/29/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "PhotoPickerCell.h"

@implementation PhotoPickerCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)getFieldValueFromform {
    if ([self.delegate respondsToSelector:@selector(getValueForField:)]) {
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *value = [self.delegate getValueForField:@"photoPicker"];
        
        //        });
    }
}

@end
