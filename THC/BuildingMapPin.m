//
//  BuildingMapPin.m
//  THC
//
//  Created by Nicolas Melo on 7/23/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "BuildingMapPin.h"
#import "BuildingCalloutView.h"

@implementation BuildingMapPin

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if(selected)
    {
        //Add your custom view to self...
        [self addSubview:self.calloutView];
    }
    else
    {
        //Remove your custom view...
        [self.calloutView removeFromSuperview];
    }
}

@end
