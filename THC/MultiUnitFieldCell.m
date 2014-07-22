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

- (void)showMenu:(CGRect)frame onView:(UIView *)view forOrientation:(UIInterfaceOrientation) orientation
{
    NSLog(@"showMenu");
    
    NSArray *multiUnitOptions = MultiUnitPetition;
    NSMutableArray *menuItems = [NSMutableArray array];
    
    for (NSString *option in multiUnitOptions) {
        [menuItems addObject:[KxMenuItem menuItem:option image:nil target:self action:@selector(pushMenuItem:)]];
    }
    NSLog(@"menu items %d", [menuItems count]);
    
    
    KxMenuItem *first = menuItems[0];
    //    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
//    first.foreColor = [UIColor greenColor];
//    
//    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu setTintColor:[UIColor orangeColor]];
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
