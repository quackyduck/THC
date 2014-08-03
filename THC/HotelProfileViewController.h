//
//  HotelProfileViewController.h
//  THC
//
//  Created by Nicolas Melo on 7/30/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Building;

@interface HotelProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithBuilding:(Building *)building andImage:(UIImage *)image;

@end
