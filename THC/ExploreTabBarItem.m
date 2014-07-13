//
//  ExploreTabBarItem.m
//  THC
//
//  Created by Nicolas Melo on 7/13/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "ExploreTabBarItem.h"

@implementation ExploreTabBarItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tabSelected = 0;
    }
    return self;
}


- (void)setTabSelected:(int)tabSelected {
    _tabSelected = tabSelected;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor* exploreBlue = [UIColor colorWithRed: 0.196f green: 0.325f blue: 0.682f alpha: 1];
    UIColor* casesBlue = [UIColor colorWithRed: 0.106f green: 0.157f blue: 0.333f alpha: 1];
    
    if (self.tabSelected == 0) {
        
        NSLog(@"Explore tab");
        
        //// Group
        {
            //// Full Tab Bar Drawing
            UIBezierPath* fullTabBarPath = [UIBezierPath bezierPathWithRect: rect];
            [casesBlue setFill];
            [fullTabBarPath fill];
            
            
            //// Explore Tab Open Drawing
            UIBezierPath* exploreTabOpenPath = UIBezierPath.bezierPath;
            [exploreTabOpenPath moveToPoint: CGPointMake(182.3f, 0.65f)];
            [exploreTabOpenPath addLineToPoint: CGPointMake(182.69f, 0.75f)];
            [exploreTabOpenPath addCurveToPoint: CGPointMake(186.58f, 3.45f) controlPoint1: CGPointMake(184.21f, 1.3f) controlPoint2: CGPointMake(185.55f, 2.24f)];
            [exploreTabOpenPath addCurveToPoint: CGPointMake(186.7f, 3.38f) controlPoint1: CGPointMake(186.66f, 3.4f) controlPoint2: CGPointMake(186.7f, 3.38f)];
            [exploreTabOpenPath addCurveToPoint: CGPointMake(187.3f, 4.41f) controlPoint1: CGPointMake(186.7f, 3.38f) controlPoint2: CGPointMake(186.91f, 3.75f)];
            [exploreTabOpenPath addCurveToPoint: CGPointMake(187.81f, 5.29f) controlPoint1: CGPointMake(187.48f, 4.69f) controlPoint2: CGPointMake(187.65f, 4.99f)];
            [exploreTabOpenPath addCurveToPoint: CGPointMake(209, 42) controlPoint1: CGPointMake(191.4f, 11.52f) controlPoint2: CGPointMake(202.91f, 31.45f)];
            [exploreTabOpenPath addCurveToPoint: CGPointMake(320, 42) controlPoint1: CGPointMake(246, 42) controlPoint2: CGPointMake(320, 42)];
            [exploreTabOpenPath addLineToPoint: CGPointMake(320, 49)];
            [exploreTabOpenPath addLineToPoint: CGPointMake(0, 49)];
            [exploreTabOpenPath addCurveToPoint: CGPointMake(0, 42) controlPoint1: CGPointMake(0, 49) controlPoint2: CGPointMake(0, 46.08f)];
            [exploreTabOpenPath addCurveToPoint: CGPointMake(0, 33.71f) controlPoint1: CGPointMake(0, 39.53f) controlPoint2: CGPointMake(0, 36.64f)];
            [exploreTabOpenPath addCurveToPoint: CGPointMake(0, 17) controlPoint1: CGPointMake(0, 33.71f) controlPoint2: CGPointMake(0, 21.57f)];
            [exploreTabOpenPath addCurveToPoint: CGPointMake(0, 15.29f) controlPoint1: CGPointMake(0, 15.94f) controlPoint2: CGPointMake(0, 15.29f)];
            [exploreTabOpenPath addCurveToPoint: CGPointMake(0.65f, 6.7f) controlPoint1: CGPointMake(0, 10.88f) controlPoint2: CGPointMake(0, 8.68f)];
            [exploreTabOpenPath addLineToPoint: CGPointMake(0.75f, 6.31f)];
            [exploreTabOpenPath addCurveToPoint: CGPointMake(6.31f, 0.75f) controlPoint1: CGPointMake(1.69f, 3.73f) controlPoint2: CGPointMake(3.73f, 1.69f)];
            [exploreTabOpenPath addCurveToPoint: CGPointMake(15.29f, 0) controlPoint1: CGPointMake(8.68f, 0) controlPoint2: CGPointMake(10.88f, 0)];
            [exploreTabOpenPath addLineToPoint: CGPointMake(173.71f, 0)];
            [exploreTabOpenPath addCurveToPoint: CGPointMake(182.3f, 0.65f) controlPoint1: CGPointMake(178.12f, 0) controlPoint2: CGPointMake(180.32f, 0)];
            [exploreTabOpenPath closePath];
            [exploreBlue setFill];
            [exploreTabOpenPath fill];
            
            //// Explore Text Drawing
            CGRect exploreTextRect = CGRectMake(51, 11, 83, 20);
            {
                NSString* textContent = @"Explore";
                NSMutableParagraphStyle* exploreTextStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
                exploreTextStyle.alignment = NSTextAlignmentCenter;
                
                NSDictionary* exploreTextFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Futura-Medium" size: UIFont.labelFontSize], NSForegroundColorAttributeName: UIColor.whiteColor, NSParagraphStyleAttributeName: exploreTextStyle};
                
                [textContent drawInRect: CGRectOffset(exploreTextRect, 0, (CGRectGetHeight(exploreTextRect) - [textContent boundingRectWithSize: exploreTextRect.size options: NSStringDrawingUsesLineFragmentOrigin attributes: exploreTextFontAttributes context: nil].size.height) / 2) withAttributes: exploreTextFontAttributes];
            }
            
            
            //// Cases Text Drawing
            CGRect casesTextRect = CGRectMake(220, 11, 83, 20);
            {
                NSString* textContent = @"Cases";
                NSMutableParagraphStyle* casesTextStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
                casesTextStyle.alignment = NSTextAlignmentCenter;
                
                NSDictionary* casesTextFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Futura-Medium" size: UIFont.labelFontSize], NSForegroundColorAttributeName: UIColor.whiteColor, NSParagraphStyleAttributeName: casesTextStyle};
                
                [textContent drawInRect: CGRectOffset(casesTextRect, 0, (CGRectGetHeight(casesTextRect) - [textContent boundingRectWithSize: casesTextRect.size options: NSStringDrawingUsesLineFragmentOrigin attributes: casesTextFontAttributes context: nil].size.height) / 2) withAttributes: casesTextFontAttributes];
            }
        }
        
    } else {
        
        NSLog(@"Case tab");
        
        //// Group
        {
            //// Rectangle Drawing
            UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: rect];
            [exploreBlue setFill];
            [rectanglePath fill];
            
            //// Bezier Drawing
            UIBezierPath* bezierPath = UIBezierPath.bezierPath;
            [bezierPath moveToPoint: CGPointMake(313.69f, 0.75f)];
            [bezierPath addCurveToPoint: CGPointMake(319.25f, 6.31f) controlPoint1: CGPointMake(316.27f, 1.69f) controlPoint2: CGPointMake(318.31f, 3.73f)];
            [bezierPath addLineToPoint: CGPointMake(319.35f, 6.7f)];
            [bezierPath addCurveToPoint: CGPointMake(320, 15.29f) controlPoint1: CGPointMake(320, 8.68f) controlPoint2: CGPointMake(320, 10.88f)];
            [bezierPath addCurveToPoint: CGPointMake(320, 16) controlPoint1: CGPointMake(320, 15.29f) controlPoint2: CGPointMake(320, 15.54f)];
            [bezierPath addCurveToPoint: CGPointMake(320, 33.71f) controlPoint1: CGPointMake(320, 16) controlPoint2: CGPointMake(320, 25.08f)];
            [bezierPath addCurveToPoint: CGPointMake(320, 42) controlPoint1: CGPointMake(320, 36.65f) controlPoint2: CGPointMake(320, 39.54f)];
            [bezierPath addCurveToPoint: CGPointMake(320, 49) controlPoint1: CGPointMake(320, 46.09f) controlPoint2: CGPointMake(320, 49)];
            [bezierPath addLineToPoint: CGPointMake(0, 49)];
            [bezierPath addLineToPoint: CGPointMake(0, 42)];
            [bezierPath addCurveToPoint: CGPointMake(111, 42) controlPoint1: CGPointMake(0, 42) controlPoint2: CGPointMake(74, 42)];
            [bezierPath addCurveToPoint: CGPointMake(132.19f, 5.29f) controlPoint1: CGPointMake(117.09f, 31.45f) controlPoint2: CGPointMake(128.6f, 11.52f)];
            [bezierPath addCurveToPoint: CGPointMake(132.7f, 4.41f) controlPoint1: CGPointMake(132.35f, 4.99f) controlPoint2: CGPointMake(132.52f, 4.69f)];
            [bezierPath addCurveToPoint: CGPointMake(133.3f, 3.38f) controlPoint1: CGPointMake(133.09f, 3.75f) controlPoint2: CGPointMake(133.3f, 3.38f)];
            [bezierPath addCurveToPoint: CGPointMake(133.42f, 3.45f) controlPoint1: CGPointMake(133.3f, 3.38f) controlPoint2: CGPointMake(133.34f, 3.4f)];
            [bezierPath addCurveToPoint: CGPointMake(137.31f, 0.75f) controlPoint1: CGPointMake(134.45f, 2.24f) controlPoint2: CGPointMake(135.79f, 1.3f)];
            [bezierPath addLineToPoint: CGPointMake(137.7f, 0.65f)];
            [bezierPath addCurveToPoint: CGPointMake(146.29f, 0) controlPoint1: CGPointMake(139.68f, 0) controlPoint2: CGPointMake(141.88f, 0)];
            [bezierPath addLineToPoint: CGPointMake(304.71f, 0)];
            [bezierPath addCurveToPoint: CGPointMake(313.69f, 0.75f) controlPoint1: CGPointMake(309.12f, 0) controlPoint2: CGPointMake(311.32f, 0)];
            [bezierPath closePath];
            [casesBlue setFill];
            [bezierPath fill];
            
            
            //// Cases Text Drawing
            CGRect casesTextRect = CGRectMake(26, 11, 61, 20);
            {
                NSString* textContent = @"Explore";
                NSMutableParagraphStyle* casesTextStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
                casesTextStyle.alignment = NSTextAlignmentCenter;
                
                NSDictionary* casesTextFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Futura-Medium" size: UIFont.labelFontSize], NSForegroundColorAttributeName: UIColor.whiteColor, NSParagraphStyleAttributeName: casesTextStyle};
                
                [textContent drawInRect: CGRectOffset(casesTextRect, 0, (CGRectGetHeight(casesTextRect) - [textContent boundingRectWithSize: casesTextRect.size options: NSStringDrawingUsesLineFragmentOrigin attributes: casesTextFontAttributes context: nil].size.height) / 2) withAttributes: casesTextFontAttributes];
            }
            
            
            //// Explore Text Drawing
            CGRect exploreTextRect = CGRectMake(201, 11, 46, 20);
            {
                NSString* textContent = @"Cases";
                NSMutableParagraphStyle* exploreTextStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
                exploreTextStyle.alignment = NSTextAlignmentCenter;
                
                NSDictionary* exploreTextFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Futura-Medium" size: UIFont.labelFontSize], NSForegroundColorAttributeName: UIColor.whiteColor, NSParagraphStyleAttributeName: exploreTextStyle};
                
                [textContent drawInRect: CGRectOffset(exploreTextRect, 0, (CGRectGetHeight(exploreTextRect) - [textContent boundingRectWithSize: exploreTextRect.size options: NSStringDrawingUsesLineFragmentOrigin attributes: exploreTextFontAttributes context: nil].size.height) / 2) withAttributes: exploreTextFontAttributes];
            }
        }
    }
}


@end
