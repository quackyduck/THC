//
//  CaseCell.h
//  THC
//
//  Created by David Bernthal on 7/5/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Case.h"

@interface CaseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *caseFirstImageView;
@property (weak, nonatomic) IBOutlet UILabel *caseIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *buildingNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

- (void)initWithCase:(Case*)myCase;

@end
