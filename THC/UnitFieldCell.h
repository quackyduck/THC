//
//  UnitFieldCell.h
//  THC
//
//  Created by Hunaid Hussain on 7/20/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnitFieldCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *unitTextField;
@end
