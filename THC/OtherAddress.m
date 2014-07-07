//
//  OtherAddress.m
//  THC
//
//  Created by Hunaid Hussain on 7/7/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "OtherAddress.h"

#define kStreet   @{FXFormFieldKey: @"streetName", FXFormFieldTitle: @"Street:", FXFormFieldInline: @YES}
#define kCity     @{FXFormFieldKey: @"city", FXFormFieldTitle: @"City:", FXFormFieldInline: @YES}
#define kState    @{FXFormFieldKey: @"state", FXFormFieldTitle: @"State:", FXFormFieldInline: @YES}
#define kZip      @{FXFormFieldKey: @"zip", FXFormFieldTitle: @"Zip:", FXFormFieldType: FXFormFieldTypeNumber, FXFormFieldInline: @YES}

@implementation OtherAddress

- (NSArray *)fields
{
    NSArray *fieldsArray = [NSArray arrayWithObjects:kStreet, kCity, kState, kZip, nil];
    return fieldsArray;
}


@end
