//
//  ContactInfoCell.h
//  THC
//
//  Created by Nicolas Melo on 7/20/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactInfoButton;
@class PhoneButton;
@interface ContactInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PhoneButton *phoneButton;
@property (weak, nonatomic) IBOutlet ContactInfoButton *emailButton;

@end
