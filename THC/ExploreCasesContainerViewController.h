//
//  ExploreCasesContainerViewController.h
//  THC
//
//  Created by Nicolas Melo on 7/12/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaseTableViewController.h"
#import "AssignmentViewController.h"

@interface ExploreCasesContainerViewController : UIViewController <CaseTableDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning, AssignmentViewDelegate>

@property (strong, nonatomic) NSArray *tabViewControllers;

@end
