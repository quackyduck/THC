//
//  AlbumListController.h
//  THC
//
//  Created by Hunaid Hussain on 7/14/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoPicker.h"

@class AsseptPicker;

@interface AlbumListController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) AsseptPicker *assetPicker;
@property (weak, nonatomic) id<PhotoPicker> delegate;

@end
