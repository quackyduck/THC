//
//  BuildingCalloutView.m
//  THC
//
//  Created by Nicolas Melo on 7/22/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "BuildingCalloutView.h"

@interface BuildingCalloutView ()



@end

@implementation BuildingCalloutView

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
- (IBAction)onTapCallout:(UITapGestureRecognizer *)sender {
    
    UIImage *image = self.imageView.image;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [userInfo setObject:image forKey:@"image"];
    [userInfo setObject:self.building forKey:@"building"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CalloutTapped" object:self userInfo:userInfo];
    
}

@end
