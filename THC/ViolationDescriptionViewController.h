//
//  ViolationDescriptionViewController.h
//  THC
//
//  Created by Hunaid Hussain on 7/6/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViolationDescriptionViewController : UIViewController <UITextViewDelegate>

//@property (retain, nonatomic) NSData *imageData;

-(NSData *) getImageData;
-(void) setImageData:(NSData *) imageData;

@end
