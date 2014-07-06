//
//  CaseCell.m
//  THC
//
//  Created by David Bernthal on 7/5/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "CaseCell.h"
#import "UIImageView+AFNetworking.h"

@implementation CaseCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithCase:(Case*)myCase;
{
    //Figure out a better case ID?
    self.caseIdLabel.text = myCase.objectId;
    //Use buildingId to query for building name
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSString *stringFromDate = [formatter stringFromDate:myCase.createdAt];

    self.timestampLabel.text = [NSString stringWithFormat:@"Created on %@", stringFromDate];
    switch (myCase.status) {
        case caseOpen:
            self.statusLabel.text = @"Status: Open";
            break;
        case caseClosed:
            self.statusLabel.text = @"Status: Closed";
            break;
        default:
            break;
    }
    
//    Query Parse for earliest image associated with this case ID
    
//    [self.caseFirstImageView setImageWithURL:nil];
//    self.profileImageView.layer.cornerRadius = 5;
//    self.profileImageView.clipsToBounds = YES;
}

@end
