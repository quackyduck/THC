//
//  OtherAddress.m
//  THC
//
//  Created by Hunaid Hussain on 7/7/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "OtherAddress.h"

@implementation OtherAddress

- (NSArray *)fields
{
    return @[
            @{FXFormFieldKey: @"streetName", FXFormFieldTitle: @"Street", FXFormFieldInline: @YES},
            @{FXFormFieldKey: @"city", FXFormFieldInline: @YES},
            @{FXFormFieldKey: @"state", FXFormFieldInline: @YES},
            @{FXFormFieldKey: @"zip", FXFormFieldType: FXFormFieldTypeNumber, FXFormFieldInline: @YES},
             ];
}


@end
