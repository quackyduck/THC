//
//  DetailFooterView.h
//  THC
//
//  Created by Nicolas Melo on 7/20/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SendEmailButton;

@interface DetailFooterView : UIView
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet SendEmailButton *sendEmailButton;

@end
