//
//  PhotoPickerCell.h
//  THC
//
//  Created by Christine Chao on 7/29/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FieldContent.h"

@interface PhotoPickerCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addPicture;
@property (weak, nonatomic) id<FieldContent> delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;

- (void)getFieldValueFromform;

@end
