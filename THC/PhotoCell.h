//
//  PhotoCell.h
//  THC
//
//  Created by Hunaid Hussain on 7/14/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectedView;

- (void)selectCell:(BOOL)selected;

@end
