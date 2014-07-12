//
//  ConfirmationCell.m
//  THC
//
//  Created by David Bernthal on 7/11/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "ConfirmationCell.h"
#import "Building.h"

@interface ConfirmationCell ()
@property (weak, nonatomic) IBOutlet UIImageView *buildingImageView;
@property (weak, nonatomic) IBOutlet UIImageView *checkMarkImageView;
@property (weak, nonatomic) IBOutlet UILabel *buildingNameLabel;

@end

@implementation ConfirmationCell

- (void)initWithBuilding:(Building*)building
{
    //Look up building image?
    self.buildingNameLabel.text = building.buildingName;
}

- (void)awakeFromNib
{
    // Initialization code
}

@end
