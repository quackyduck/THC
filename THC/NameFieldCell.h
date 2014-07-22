//
//  NameFieldCell.h
//  THC
//
//  Created by Hunaid Hussain on 7/20/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FieldContent.h"

@interface NameFieldCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) id<FieldContent> delegate;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

- (void)getFieldValueFromform;

@end
