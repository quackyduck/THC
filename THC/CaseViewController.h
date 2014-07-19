//
//  CaseViewController.h
//  THC
//
//  Created by Nicolas Melo on 7/18/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Case;
@interface CaseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithCase:(Case *)caseInfo;

@end
