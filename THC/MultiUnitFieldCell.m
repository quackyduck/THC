//
//  MultiUnitFieldCell.m
//  THC
//
//  Created by Hunaid Hussain on 7/21/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "MultiUnitFieldCell.h"
#import "KxMenu.h"

#define MultiUnitPetition @[@"YES", @"NO"]
#define orangeColor [UIColor colorWithRed: 255.0f/255.0f green: 116.0f/255.0f blue: 47.0f/255.0f alpha: 1]

@implementation MultiUnitFieldCell

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
        
            NSString *value = [self.delegate getValueForField:@"multiUnitPetiiton"];
            if (value != nil && ![value isEqualToString:@""]) {
                self.multiUnitField.text = value;
            }
//        });
    }
}

- (void)showMenu:(CGRect)frame onView:(UIView *)view forOrientation:(UIInterfaceOrientation) orientation
{
    
    NSArray *multiUnitOptions = MultiUnitPetition;
    NSMutableArray *menuItems = [NSMutableArray array];
    
    [menuItems addObject:[KxMenuItem menuItem:@"Is Multi-Unit Petition" image:nil target:nil action:nil]];

    for (NSString *option in multiUnitOptions) {
        KxMenuItem *item = [KxMenuItem menuItem:option image:nil target:self action:@selector(pushMenuItem:)];
        item.foreColor = [UIColor grayColor];
        item.alignment = NSTextAlignmentCenter;
        [menuItems addObject:item];
    }
    
    
    KxMenuItem *first = menuItems[0];
    //    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    first.foreColor = orangeColor;
//
    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu setTintColor:[UIColor whiteColor]];
    [KxMenu showMenuInView:view
                  fromRect:frame
                 menuItems:menuItems
            forOrientation:orientation ];
    
}

- (void) pushMenuItem:(id)sender
{
    KxMenuItem *menu = (KxMenuItem *) sender;
    
    self.multiUnitField.text = menu.title;
    self.multiUnitField.textColor = [UIColor blackColor];
    
    if ([self.delegate respondsToSelector:@selector(setValue:forField:)]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self.delegate setValue:menu.title forField:@"multiUnitPetiiton"];
        });
    }
    
    [self setNeedsDisplay];
}

@end
