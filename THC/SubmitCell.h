//
//  SubmitCell.h
//  THC
//
//  Created by Hunaid Hussain on 7/21/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FieldContent.h"


@interface SubmitCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

- (IBAction)submitTheForm:(UIButton *)sender;

@property (weak, nonatomic) id<FieldContent> delegate;


@end
