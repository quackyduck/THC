//
//  SubmitCell.m
//  THC
//
//  Created by Hunaid Hussain on 7/21/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "SubmitCell.h"

@implementation SubmitCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)submitTheForm:(UIButton *)sender {
//    NSLog(@"To implement submit");
    [self.submitDelegate submitForm];
}
@end
