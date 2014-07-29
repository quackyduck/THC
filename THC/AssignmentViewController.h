//
//  AssignmentViewController.h
//  THC
//
//  Created by David Bernthal on 7/26/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Case.h"

@protocol AssignmentViewDelegate <NSObject>
@required
- (void)reloadTable;
@end

@interface AssignmentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Case* assignToCase;
@property (assign) id<AssignmentViewDelegate> delegate;

- (id)initWithCase:(Case*)assignToCase;

@end
