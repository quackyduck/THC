//
//  BuildingAnnotationView.m
//  THC
//
//  Created by Nicolas Melo on 7/17/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "BuildingAnnotationView.h"

@implementation BuildingAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    //// Color Declarations
    UIColor* color2 = [UIColor colorWithRed: 1 green: 0.455f blue: 0.184f alpha: 1];
    UIColor* color5 = [UIColor colorWithRed: 0.667f green: 0.667f blue: 0.667f alpha: 0.35f];
    
    //// Group
    {
        //// Oval 3 Drawing
        UIBezierPath* oval3Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(rect.origin.x, rect.origin.y, 35, 35)];
        [color5 setFill];
        [oval3Path fill];
        
        
        //// Oval Drawing
        CGRect ovalRect = CGRectMake(rect.origin.x + 2.5f, rect.origin.y + 2.5f, 30, 30);
        UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: ovalRect];
        [color2 setFill];
        [ovalPath fill];
        {
            NSString* textContent = [NSString stringWithFormat:@"%d", self.numberOfCases];
            NSMutableParagraphStyle* ovalStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
            ovalStyle.alignment = NSTextAlignmentCenter;
            
            NSDictionary* ovalFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Bold" size: 17.5], NSForegroundColorAttributeName: UIColor.whiteColor, NSParagraphStyleAttributeName: ovalStyle};
            
            [textContent drawInRect: CGRectOffset(ovalRect, 0, (CGRectGetHeight(ovalRect) - [textContent boundingRectWithSize: ovalRect.size options: NSStringDrawingUsesLineFragmentOrigin attributes: ovalFontAttributes context: nil].size.height) / 2) withAttributes: ovalFontAttributes];
        }
    }

}

@end
