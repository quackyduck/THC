//
//  ViolationTypeFieldCell.m
//  THC
//
//  Created by Hunaid Hussain on 7/20/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "ViolationTypeFieldCell.h"
#import "KxMenu.h"

#define orangeColor [UIColor colorWithRed: 255.0f/255.0f green: 116.0f/255.0f blue: 47.0f/255.0f alpha: 1]
//#define ViolationTypeList @[@"Mold", @"Leaks", @"Graffiti", @"Trash", @"Violence", @"Noise", @"Harrasment", @"Other"]
#define ViolationTypeList @[@"Mold", @"Pests", @"Leaks", @"No working heater", @"Non functioning elevator", @"No hot Water", @"Broken Windows/Doors/Walls", @"Obstruction of Egress", @"General Maintenance", @"Security", @"Fire Detector", @"Carbon Mono Oxide Detector"]
@implementation ViolationTypeFieldCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)getFieldValueFromform {
    if ([self.delegate respondsToSelector:@selector(getValueForField:)]) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            NSString *value = [self.delegate getValueForField:@"violationType"];
            if (value != nil && ![value isEqualToString:@""]) {
                self.violationTypeTextField.text = value;
            }
//        });
    }
}

- (void)showMenu:(CGRect)frame onView:(UIView *)view forOrientation:(UIInterfaceOrientation) orientation
{
    
    NSArray *violations = ViolationTypeList;
    NSMutableArray *menuItems = [NSMutableArray array];
    
    [menuItems addObject:[KxMenuItem menuItem:@"Select Violation Type" image:nil target:nil action:nil]];

    for (NSString *violation in violations) {
        KxMenuItem *item = [KxMenuItem menuItem:violation image:nil target:self action:@selector(pushMenuItem:)];
        item.foreColor = [UIColor grayColor];
        item.alignment = NSTextAlignmentCenter;
        [menuItems addObject:item];
    }
    
    
    KxMenuItem *first = menuItems[0];
    //    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    first.foreColor = orangeColor;
    
    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu setTintColor:[UIColor colorWithRed: 230.0f/255.0f green: 230.0f/255.0f blue: 230.0f/255.0f alpha: 1]];
    [KxMenu showMenuInView:view
                  fromRect:frame
                 menuItems:menuItems
            forOrientation:orientation ];
    
}

- (void) pushMenuItem:(id)sender
{
    KxMenuItem *menu = (KxMenuItem *) sender;
    
    self.violationTypeTextField.text = menu.title;
    self.violationTypeTextField.textColor = [UIColor blackColor];
    
    if ([self.delegate respondsToSelector:@selector(setValue:forField:)]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self.delegate setValue:menu.title forField:@"violationType"];
        });
    }

    [self setNeedsDisplay];
}

@end
