//
//  CaseCell.h
//  THC
//
//  Created by David Bernthal on 7/5/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Case.h"

@protocol CaseCellDelegate <NSObject>
@required
- (void)showAssignmentView:(Case*)swipedCase;
@end

@interface CaseCell : UITableViewCell <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *caseFirstImageView;
@property (weak, nonatomic) IBOutlet UILabel *caseIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *buildingNameLabel;
@property (weak, nonatomic) IBOutlet UIView *timestampBackgroudView;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIView *scrollViewContentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property BOOL didShowAssignmentTable;
@property (strong, nonatomic) Case* cellCase;

@property (assign) id<CaseCellDelegate> delegate;

- (void)initWithCase:(Case*)myCase showAssignment:(BOOL)assignment;

@end
