//
//  SpokenLanguageFieldCell.h
//  THC
//
//  Created by Hunaid Hussain on 7/20/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FieldContent.h"

@interface SpokenLanguageFieldCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *languageLabel;
@property (weak, nonatomic) id<FieldContent> delegate;

- (void)showMenu:(CGRect)frame onView:(UIView *)view forOrientation:(UIInterfaceOrientation) orientation;

@end
