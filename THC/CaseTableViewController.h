//
//  CaseTableViewController.h
//  THC
//
//  Created by David Bernthal on 7/5/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaseCell.h"

@protocol CaseTableDelegate <NSObject>
@required
- (void)showAssignmentView:(Case*)swipedCase;
@end

@interface CaseTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CaseCellDelegate>

@property (assign) id<CaseTableDelegate> delegate;

@end
