//
//  DetailFooterView.m
//  THC
//
//  Created by Nicolas Melo on 7/20/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "DetailFooterView.h"
#import "SendEmailButton.h"

@interface DetailFooterView()
@property (weak, nonatomic) IBOutlet SendEmailButton *sendEmailButton;

@end

@implementation DetailFooterView

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

@end
