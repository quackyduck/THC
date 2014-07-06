//
//  AddressForm.m
//  THC
//
//  Created by Hunaid Hussain on 7/6/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "AddressForm.h"

@implementation AddressForm

- (NSDictionary *)hotelNameField
{
    return @{
             FXFormFieldOptions: @[@"Allstar Hotel", @"Boyd Hotel", @"Caldrake Hotel", @"Edgeworth Hotel", @"Elk Hotel", @"Galvin Apartments", @"Graystone Hotel", @"Hartland Hotel", @"Hotel Union", @"Jefferson Hotel", @"Mayfair Hotel", @"Mission Hotel", @"Pierre Hotel", @"Pierre Hotel", @"Raman Hotel", @"Royan Hotel", @"Seneca Hotel", @"Vincent Hotel", @"Other"],
             FXFormFieldCell: [FXFormOptionPickerCell class],
             };
}

- (NSDictionary *)otherField
{
    if ([self.hotelName isEqualToString:@"Other"]) {
        return @{FXFormFieldKey: @"Other Address", FXFormFieldType: FXFormFieldTypeText};
    }
    return nil;
    
}

@end
