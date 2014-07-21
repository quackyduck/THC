//
//  ViolationTypeFieldCell.m
//  THC
//
//  Created by Hunaid Hussain on 7/20/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "ViolationTypeFieldCell.h"
#import "KxMenu.h"

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

- (void)showMenu:(CGRect)frame onView:(UIView *)view forOrientation:(UIInterfaceOrientation) orientation
{
    NSLog(@"showMenu");
    
    NSArray *violations = ViolationTypeList;
    NSMutableArray *menuItems = [NSMutableArray array];
    
    for (NSString *violation in violations) {
        [menuItems addObject:[KxMenuItem menuItem:violation image:nil target:self action:@selector(pushMenuItem:)]];
    }
    NSLog(@"menu items %d", [menuItems count]);
    
    
    KxMenuItem *first = menuItems[0];
    //    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    first.foreColor = [UIColor greenColor];
    
    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu setTintColor:[UIColor orangeColor]];
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
