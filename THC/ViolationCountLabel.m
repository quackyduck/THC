//
//  ViolationCountLabel.m
//  THC
//
//  Created by Nicolas Melo on 8/3/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "ViolationCountLabel.h"

@implementation ViolationCountLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {2, 5, 2, 4};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
