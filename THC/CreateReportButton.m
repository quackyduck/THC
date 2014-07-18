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
    
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* tHCButtonGray = [UIColor colorWithRed: 0.965f green: 0.965f blue: 0.965f alpha: 1];
    UIColor* tHCOrange = [UIColor colorWithRed: 1 green: 0.455f blue: 0.184f alpha: 1];
    UIColor* buttonStrokeColor = [UIColor colorWithRed: 0.882f green: 0.886f blue: 0.89f alpha: 1];
    UIColor* shadow2Color = [UIColor colorWithRed: 0.725f green: 0.725f blue: 0.733f alpha: 1];
    
    //// Shadow Declarations
    UIColor* buttonShadow = shadow2Color;
    CGSize buttonShadowOffset = CGSizeMake(1.5f, 1.5f);
    CGFloat buttonShadowBlurRadius = 1;
    
    //// Group
    {
        //// Rectangle Drawing
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0.5f, 0.25f, 319, 49)];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, buttonShadowOffset, buttonShadowBlurRadius, [buttonShadow CGColor]);
        [tHCButtonGray setFill];
        [rectanglePath fill];
        CGContextRestoreGState(context);
        
        [buttonStrokeColor setStroke];
        rectanglePath.lineWidth = 0.5f;
        [rectanglePath stroke];
        
        
        //// Create New Report Drawing
        CGRect createNewReportRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width - 1, rect.size.height);
        {
            NSString* textContent = @"Create New Report";
            NSMutableParagraphStyle* createNewReportStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
            createNewReportStyle.alignment = NSTextAlignmentCenter;
            
            NSDictionary* createNewReportFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Bold" size: UIFont.labelFontSize], NSForegroundColorAttributeName: tHCOrange, NSParagraphStyleAttributeName: createNewReportStyle};
            
            [textContent drawInRect: CGRectOffset(createNewReportRect, 0, (CGRectGetHeight(createNewReportRect) - [textContent boundingRectWithSize: createNewReportRect.size options: NSStringDrawingUsesLineFragmentOrigin attributes: createNewReportFontAttributes context: nil].size.height) / 2) withAttributes: createNewReportFontAttributes];
        }
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
