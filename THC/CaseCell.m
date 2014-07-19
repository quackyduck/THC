//
//  CaseCell.m
//  THC
//
//  Created by David Bernthal on 7/5/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "CaseCell.h"
#import "UIImageView+AFNetworking.h"
#import "BuildingPhoto.h"
#import "Building.h"

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
    self.caseIdLabel.text = [NSString stringWithFormat:@"Case #%@", myCase.caseId];
    
    //Use buildingId to query for building name
    PFQuery *query = [Building query];
    [query whereKey:@"objectId" equalTo:myCase.buildingId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0)
            {
                Building* building = objects[0];
                self.buildingNameLabel.text = building.buildingName;
            }
        }
    }];
    
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
    
    //Get first image to show
    PFQuery *photoQuery = [BuildingPhoto query];
    [photoQuery whereKey:@"buildingId" equalTo:myCase.buildingId];
    [photoQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0)
            {
                BuildingPhoto* photoObject = objects[0];
                PFFile *photo = photoObject.image;
                NSData *imageData = [photo getData];
                UIImage *image = [UIImage imageWithData:imageData];
                [self.caseFirstImageView setImage:image];
            }
        }
    }];
}

@end
