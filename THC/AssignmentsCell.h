//
//  AssignmentsCell.h
//  THC
//
//  Created by David Bernthal on 7/26/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Assignment.h"

@interface AssignmentsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

- (void)initWithAssignment:(Assignment *)assignment;

@end
