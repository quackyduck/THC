//
//  CreateReportButton.m
//  THC
//
//  Created by Nicolas Melo on 7/12/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "CreateReportButton.h"

@implementation CreateReportButton

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
    UIColor* peaGreen = [UIColor colorWithRed: 0.949f green: 1 blue: 0.831f alpha: 1];
    UIColor* exploreBlue = [UIColor colorWithRed: 0.196f green: 0.325f blue: 0.682f alpha: 1];
    
    if (self.state == UIControlStateHighlighted) {
        peaGreen = [UIColor colorWithRed: 0.949f green: 1 blue: 0.831f alpha: 0.5f];
    }
    
    //// Rectangle Drawing
    CGRect rectangleRect = rect;
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: rectangleRect cornerRadius: 5];
    [peaGreen setFill];
    [rectanglePath fill];
    [UIColor.darkGrayColor setStroke];
    rectanglePath.lineWidth = 1;
    [rectanglePath stroke];
    {
        NSString* textContent = @"+ Create Report";
        NSMutableParagraphStyle* rectangleStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        rectangleStyle.alignment = NSTextAlignmentCenter;
        
        NSDictionary* rectangleFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Futura-Medium" size: UIFont.buttonFontSize], NSForegroundColorAttributeName: exploreBlue, NSParagraphStyleAttributeName: rectangleStyle};
        
        [textContent drawInRect: CGRectOffset(rectangleRect, 0, (CGRectGetHeight(rectangleRect) - [textContent boundingRectWithSize: rectangleRect.size options: NSStringDrawingUsesLineFragmentOrigin attributes: rectangleFontAttributes context: nil].size.height) / 2) withAttributes: rectangleFontAttributes];
    }


}

-(void)setHighlighted:(BOOL)value {
    [super setHighlighted:value];
    [self setNeedsDisplay];
}

-(void)setSelected:(BOOL)value {
    [super setSelected:value];
    [self setNeedsDisplay];
}

-(void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self setNeedsDisplay];
}

@end
