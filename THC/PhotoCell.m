//
//  PhotoCell.m
//  THC
//
//  Created by Hunaid Hussain on 7/14/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

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

- (void)selectCell:(BOOL)selected {
    if (selected) {
//        NSLog(@"Adding selected view %@", self.selectedView);
        [self.selectedView setHidden:NO];
        [self.imageView addSubview:self.selectedView];
    }
    else {
        [self.selectedView setHidden:YES];
    }
    [self setNeedsDisplay];
}

@end
