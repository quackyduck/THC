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
#import "PhotoInfo.h"
#import <math.h>

#define optionViewWidth 140

@implementation CaseCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithCase:(Case*)myCase showAssignment:(BOOL)assignment enableScroll:(BOOL)enable containingTable:(UITableView*)table {
    [self initWithCase:myCase showAssignment:assignment enableScroll:enable containingTable:table displayDescription:NO useGray:NO];
}

- (void)initWithCase:(Case*)myCase showAssignment:(BOOL)assignment enableScroll:(BOOL)enable containingTable:(UITableView*)table displayDescription:(BOOL)display useGray:(BOOL)gray
{
    if (gray) {
        self.scrollViewContentView.backgroundColor = [UIColor colorWithRed:224/255.0f green:232/255.0f blue:234/255.0f alpha:1.0f];
    }
    
    self.cellCase = myCase;
    self.caseIdLabel.text = [NSString stringWithFormat:@"Case #%@", myCase.objectId];
    [self.scrollView setContentOffset:CGPointZero];
    
    self.enableScroll = enable;
    self.table = table;
    
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
    if (myCase.status == caseClosed)
    {
        self.timeStampLabel.text = @"";
        self.statusLabel.text = @"Closed";
        self.timestampBackgroudView.backgroundColor = [UIColor blueColor];
    } else if (assignment)
    {
        self.statusLabel.text = @"Assigned To";
        //Hack, dual purpose label
        
        PFQuery *query = [PFUser query];
        [query whereKey:@"objectId" equalTo:myCase.userId];
        query.cachePolicy = kPFCachePolicyCacheElseNetwork;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error && objects.count > 0) {
                PFUser* user = [NSMutableArray arrayWithArray:objects][0];
                self.timeStampLabel.text = [NSString stringWithFormat:@"%@ %@.", [user objectForKey:@"firstName"],
                        [[user objectForKey:@"lastName"] substringToIndex:1]];
            } else
            {
                self.timeStampLabel.text = @"No One";
            }
        }];
        self.timestampBackgroudView.backgroundColor = [UIColor redColor];
    } else
    {
        self.statusLabel.text = @"Created";
        self.timestampBackgroudView.backgroundColor = [UIColor orangeColor];
    }
    
    [self.timeStampLabel sizeToFit];
    CGRect newFrame = self.timestampBackgroudView.frame;
    if (myCase.status == caseClosed) {
        newFrame.size.width = self.timeStampLabel.frame.size.width + 55;
    } else if (assignment)
    {
        newFrame.size.width = self.timeStampLabel.frame.size.width + 90;
    } else
    {
        CGRect newLabelFrame = self.timeStampLabel.frame;
        newLabelFrame.origin.x = self.timeStampLabel.frame.origin.x - 20;
        [self.timeStampLabel setFrame:newLabelFrame];
        newFrame.size.width = self.timeStampLabel.frame.size.width + 100;
    }
    [self.timestampBackgroudView setFrame:newFrame];
    self.timestampBackgroudView.layer.cornerRadius = 3;
    self.timestampBackgroudView.layer.masksToBounds = YES;
    
    if (display) {
        
        if (myCase.violationDetails == nil || [myCase.violationDetails isEqualToString:@""]) {
            self.buildingNameLabel.text = @"No Description";
        } else {
            self.buildingNameLabel.text = myCase.violationDetails;
            [self.buildingNameLabel sizeToFit];
        }
        
        if (myCase.photoIdList.count > 0) {
        
            //Get first image to show
            PFQuery *photoQuery = [PhotoInfo query];
            photoQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
            [photoQuery whereKey:@"objectId" equalTo:myCase.photoIdList[0]];
            [photoQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    if (objects.count > 0)
                    {
                        PhotoInfo* photoObject = objects[0];
                        PFFile *photo = photoObject.image;
                        [photo getDataInBackgroundWithBlock:^(NSData *data, NSError *photoError) {
                            if (!photoError) {
                                NSData *imageData = data;
                                UIImage *image = [UIImage imageWithData:imageData];
                                [self.caseFirstImageView setImage:image];
                                
                                self.caseFirstImageView.layer.cornerRadius = 35;
                                self.caseFirstImageView.layer.masksToBounds = YES;
                            }
                        }];
                        
                    }
                }
            }];
        } else {
            //Get first image to show
            PFQuery *photoQuery = [BuildingPhoto query];
            photoQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
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
                                
                                self.caseFirstImageView.layer.cornerRadius = 35;
                                self.caseFirstImageView.layer.masksToBounds = YES;
                            }
                        }];
                        
                    }
                }
            }];
        }
        
        self.caseFirstImageView.layer.borderWidth = 2.0f;
        self.caseFirstImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        
    } else {
    
        if (myCase.buildingId == nil) {
            myCase.buildingId = @"hmleALJfn5";
        }
        
        //Use buildingId to query for building name
        PFQuery *query = [Building query];
        query.cachePolicy = kPFCachePolicyCacheElseNetwork;
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
        photoQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
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
                            
                            self.caseFirstImageView.layer.cornerRadius = 35;
                            self.caseFirstImageView.layer.masksToBounds = YES;
                        }
                    }];
                    
                }
            }
        }];
    }
}


#pragma mark - Private Methods


#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if (scrollView.contentOffset.x > optionViewWidth / 2) {
        targetContentOffset->x = optionViewWidth;
    } else {
        *targetContentOffset = CGPointZero;
        
        // Need to call this subsequently to remove flickering -- TODO: check why
        dispatch_async(dispatch_get_main_queue(), ^{
            [scrollView setContentOffset:CGPointZero animated:YES];
        });
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x < 0 || !self.enableScroll)
    {
        scrollView.contentOffset = CGPointZero;
    } else if (scrollView.contentOffset.x > 170)
    {
        if (!self.didShowAssignmentTable)
        {
            self.didShowAssignmentTable = YES;
            [self.delegate didScroll:self.cellCase index:[self.table indexPathForCell:self]];
        }
    } else
    {
    }
}

@end
