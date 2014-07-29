//
//  AssignmentsCell.m
//  THC
//
//  Created by David Bernthal on 7/26/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "AssignmentsCell.h"

@implementation AssignmentsCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithAssignment:(Assignment *)assignment
{
    self.userNameLabel.text = assignment.userName;
}

@end
