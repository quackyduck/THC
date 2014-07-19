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
#import <math.h>

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
    
    //Setup timestamp view
    self.timestampBackgroudView.backgroundColor = [UIColor orangeColor];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:myCase.createdAt];
    if (timeInterval < 60.0) //under a minute
    {
        self.timeStampLabel.text = [NSString stringWithFormat:@"%.0f seconds ago", timeInterval];
    } else if (timeInterval < 60.0 * 60.0) //under an hour
    {
        NSTimeInterval intervalInMinutes = floor(timeInterval/60.0);
        if (intervalInMinutes == 1)
            self.timeStampLabel.text = [NSString stringWithFormat:@"%.0f minute ago", intervalInMinutes];
        else
            self.timeStampLabel.text = [NSString stringWithFormat:@"%.0f minutes ago", intervalInMinutes];
    } else if (timeInterval < 60.0 * 60.0 * 24.0) //under a day
    {
        NSTimeInterval intervalInHours = floor(timeInterval/60.0/60.0);
        if (intervalInHours == 1)
            self.timeStampLabel.text = [NSString stringWithFormat:@"%.0f hour ago", intervalInHours];
        else
            self.timeStampLabel.text = [NSString stringWithFormat:@"%.0f hours ago", intervalInHours];
    } else if (timeInterval < 60.0 * 60.0 * 24.0 * 7.0) //under a week
    {
        NSTimeInterval intervalInDays = floor(timeInterval/60.0/60.0/24.0);
        if (intervalInDays == 1)
            self.timeStampLabel.text = [NSString stringWithFormat:@"%.0f day ago", intervalInDays];
        else
            self.timeStampLabel.text = [NSString stringWithFormat:@"%.0f days ago", intervalInDays];
    } else //more than a week
    {
        NSTimeInterval intervalInWeeks = floor(timeInterval/60.0/60.0/24.0/7.0);
        if (intervalInWeeks == 1)
            self.timeStampLabel.text = [NSString stringWithFormat:@"%.0f week ago", intervalInWeeks];
        else
            self.timeStampLabel.text = [NSString stringWithFormat:@"%.0f weeks ago", intervalInWeeks];
    }
    [self.timeStampLabel sizeToFit];
    CGRect newFrame = self.timestampBackgroudView.frame;
    newFrame.size.width = self.timeStampLabel.frame.size.width + 70;
    [self.timestampBackgroudView setFrame:newFrame];
    self.timestampBackgroudView.layer.cornerRadius = 3;
    self.timestampBackgroudView.layer.masksToBounds = YES;
    
    
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
    
    //Get first image to show
    PFQuery *photoQuery = [BuildingPhoto query];
    [photoQuery whereKey:@"buildingId" equalTo:myCase.buildingId];
    [photoQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0)
            {
                BuildingPhoto* photoObject = objects[0];
                PFFile *photo = photoObject.image;
                [photo getDataInBackgroundWithBlock:^(NSData *data, NSError *photoError) {
                    if (!photoError) {
                        NSData *imageData = data;
                        UIImage *image = [UIImage imageWithData:imageData];
                        [self.caseFirstImageView setImage:image];
                    }
                }];
                
            }
        }
    }];
}

@end
