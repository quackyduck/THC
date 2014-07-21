//
//  HotelFieldCell.m
//  THC
//
//  Created by Hunaid Hussain on 7/20/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "HotelFieldCell.h"
#import "KxMenu.h"

//#define HotelList @[@"English", @"Spanish", @"Chinese", @"Mandarin", @"Vietnami", @"Phillipino", @"Punjabi", @"Hindi", @"Gujrati"]
#define HotelList @[@"Allstar Hotel", @"Boyd Hotel", @"Caldrake Hotel", @"Edgeworth Hotel", @"Elk Hotel", @"Galvin Apartments", @"Graystone Hotel", @"Hartland Hotel", @"Hotel Union", @"Jefferson Hotel", @"Mayfair Hotel", @"Mission Hotel", @"Pierre Hotel", @"Pierre Hotel", @"Raman Hotel", @"Royan Hotel", @"Seneca Hotel", @"Vincent Hotel"]
@implementation HotelFieldCell

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
    
    NSArray *hotels = HotelList;
    NSMutableArray *menuItems = [NSMutableArray array];
    
    for (NSString *hotel in hotels) {
        [menuItems addObject:[KxMenuItem menuItem:hotel image:nil target:self action:@selector(pushMenuItem:)]];
    }
    NSLog(@"menu items %d", [menuItems count]);
    
    //    NSArray *menuItems =
    //    @[
    //
    //      //      [KxMenuItem menuItem:@"ACTION MENU 1234456"
    //      //                     image:nil
    //      //                    target:nil
    //      //                    action:NULL],
    //
    //      [KxMenuItem menuItem:@"English"
    //       //                     image:[UIImage imageNamed:@"action_icon"]
    //                     image:nil
    //                    target:self
    //                    action:@selector(pushMenuItem:)],
    //
    //      [KxMenuItem menuItem:@"Spanish"
    //                     image:nil
    //                    target:self
    //                    action:@selector(pushMenuItem:)],
    //
    //      [KxMenuItem menuItem:@"Chinese"
    //       //                     image:[UIImage imageNamed:@"reload"]
    //                     image:nil
    //                    target:self
    //                    action:@selector(pushMenuItem:)],
    //
    //      [KxMenuItem menuItem:@"Vietnami"
    //       //                     image:[UIImage imageNamed:@"search_icon"]
    //                     image:nil
    //                    target:self
    //                    action:@selector(pushMenuItem:)],
    //
    //      [KxMenuItem menuItem:@"Mandarin"
    //       //                     image:[UIImage imageNamed:@"home_icon"]
    //                     image:nil
    //                    target:self
    //                    action:@selector(pushMenuItem:)],
    //
    //      [KxMenuItem menuItem:@"Philipino"
    //       //                     image:[UIImage imageNamed:@"home_icon"]
    //                     image:nil
    //                    target:self
    //                    action:@selector(pushMenuItem:)],
    //
    //      [KxMenuItem menuItem:@"Punjabi"
    //       //                     image:[UIImage imageNamed:@"home_icon"]
    //                     image:nil
    //                    target:self
    //                    action:@selector(pushMenuItem:)],
    //
    //      [KxMenuItem menuItem:@"Hindi"
    //       //                     image:[UIImage imageNamed:@"home_icon"]
    //                     image:nil
    //                    target:self
    //                    action:@selector(pushMenuItem:)],
    //
    //      [KxMenuItem menuItem:@"Kannad"
    //       //                     image:[UIImage imageNamed:@"home_icon"]
    //                     image:nil
    //                    target:self
    //                    action:@selector(pushMenuItem:)],
    //
    //      [KxMenuItem menuItem:@"Gujrati"
    //       //                     image:[UIImage imageNamed:@"home_icon"]
    //                     image:nil
    //                    target:self
    //                    action:@selector(pushMenuItem:)],
    //
    //      [KxMenuItem menuItem:@"Bengali"
    //       //                     image:[UIImage imageNamed:@"home_icon"]
    //                     image:nil
    //                    target:self
    //                    action:@selector(pushMenuItem:)],
    //
    //      [KxMenuItem menuItem:@"Manipuri"
    //       //                     image:[UIImage imageNamed:@"home_icon"]
    //                     image:nil
    //                    target:self
    //                    action:@selector(pushMenuItem:)],
    //
    //      [KxMenuItem menuItem:@"Oriya"
    //       //                     image:[UIImage imageNamed:@"home_icon"]
    //                     image:nil
    //                    target:self
    //                    action:@selector(pushMenuItem:)],
    //
    //      [KxMenuItem menuItem:@"Chaatisgarhi"
    //       //                     image:[UIImage imageNamed:@"home_icon"]
    //                     image:nil
    //                    target:self
    //                    action:@selector(pushMenuItem:)],
    //      [KxMenuItem menuItem:@"Marathi"
    //       //                     image:[UIImage imageNamed:@"home_icon"]
    //                     image:nil
    //                    target:self
    //                    action:@selector(pushMenuItem:)],
    //
    //      [KxMenuItem menuItem:@"Malyalam"
    //       //                     image:[UIImage imageNamed:@"home_icon"]
    //                     image:nil
    //                    target:self
    //                    action:@selector(pushMenuItem:)],
    //
    //      [KxMenuItem menuItem:@"Telgu"
    //       //                     image:[UIImage imageNamed:@"home_icon"]
    //                     image:nil
    //                    target:self
    //                    action:@selector(pushMenuItem:)],
    //
    //      [KxMenuItem menuItem:@"Bihari"
    //       //                     image:[UIImage imageNamed:@"home_icon"]
    //                     image:nil
    //                    target:self
    //                    action:@selector(pushMenuItem:)],
    //
    //      [KxMenuItem menuItem:@"Devnagri"
    //       //                     image:[UIImage imageNamed:@"home_icon"]
    //                     image:nil
    //                    target:self
    //                    action:@selector(pushMenuItem:)],
    //
    //      ];
    
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
    
    self.hotelLabel.text = menu.title;
    self.hotelLabel.textColor = [UIColor blackColor];
    
    if ([self.delegate respondsToSelector:@selector(setValue:forField:)]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self.delegate setValue:menu.title forField:@"selectedHotel"];
        });
    }
    
    [self setNeedsDisplay];
}

@end
