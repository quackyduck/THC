//
//  BuildingMapPin.m
//  THC
//
//  Created by Nicolas Melo on 7/23/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "BuildingMapPin.h"
#import "BuildingCalloutView.h"
#import "Building.h"
#import "BuildingPhoto.h"

#import <Parse/Parse.h>

@implementation BuildingMapPin

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if(selected)
    {
        //Add your custom view to self...
        [self addSubview:self.calloutView];
    }
    else
    {
        //Remove your custom view...
        [self.calloutView removeFromSuperview];
    }
}

- (void)configureAnnotationWithBuilding:(Building *)building {
    //Get first image to show
    PFQuery *photoQuery = [BuildingPhoto query];
    [photoQuery whereKey:@"buildingId" equalTo:building.objectId];
    [photoQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0)
            {
                BuildingPhoto* photoObject = objects[0];
                PFFile *photo = photoObject.image;
                [photo getDataInBackgroundWithBlock:^(NSData *data, NSError *photoError) {
                    if (!photoError) {
                        NSData *imageData = data;
                        UIImage *image = [UIImage imageWithData:imageData];
                        
                        CGRect resizeRect = CGRectMake(0, 0, 32, 32);
                        UIGraphicsBeginImageContext(resizeRect.size);
                        [image drawInRect:resizeRect];
                        UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        self.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:resizedImage];
                        
                    }
                }];
                
            }
        }
    }];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Case"];
    [query whereKey:@"buildingId" equalTo:building.objectId];
    [query whereKey:@"status" equalTo:@0];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully got %lu cases for building %@", (unsigned long)objects.count, building.buildingName);
            NSString *text = [NSString stringWithFormat:@"%lu", objects.count];
            UIImage *pin = [UIImage imageNamed:@"btn_map_pin_normal"];
            CGPoint point = CGPointMake(self.bounds.origin.x + pin.size.width / 2.5f, self.bounds.origin.y + 15);
            
            UIFont *font = [UIFont boldSystemFontOfSize:16];
            UIGraphicsBeginImageContextWithOptions(pin.size, NO, 0);
            [pin drawInRect:CGRectMake(0, 0, pin.size.width, pin.size.height)];
            CGRect rect = CGRectMake(point.x, point.y, pin.size.width, pin.size.height);
            [text drawInRect:rect withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor whiteColor]}];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            self.image = newImage;
            [self setNeedsDisplay];
            
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

@end
