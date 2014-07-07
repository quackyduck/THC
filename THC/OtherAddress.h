//
//  OtherAddress.h
//  THC
//
//  Created by Hunaid Hussain on 7/7/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"

@interface OtherAddress : NSObject <FXForm>

@property (strong, nonatomic) NSString    *streetName;
@property (strong, nonatomic) NSString    *city;
@property (strong, nonatomic) NSString    *state;
@property (strong, nonatomic) NSString    *zip;

@end
