//
//  AddressForm.m
//  THC
//
//  Created by Hunaid Hussain on 7/6/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "AddressForm.h"

@implementation AddressForm

- (NSArray *)fields
{
    NSLog(@"In adress field");
    if (self.showOtherAddress) {
        NSLog(@"Showing other adress field");
        return @[
                 @{FXFormFieldKey: @"hotelName", FXFormFieldOptions: @[@"Allstar Hotel", @"Boyd Hotel", @"Caldrake Hotel", @"Edgeworth Hotel", @"Elk Hotel", @"Galvin Apartments", @"Graystone Hotel", @"Hartland Hotel", @"Hotel Union", @"Jefferson Hotel", @"Mayfair Hotel", @"Mission Hotel", @"Pierre Hotel", @"Pierre Hotel", @"Raman Hotel", @"Royan Hotel", @"Seneca Hotel", @"Vincent Hotel", @"Other"],
                   FXFormFieldCell: [FXFormOptionPickerCell class], FXFormFieldAction: @"changeAddress"
                   },
                 @{FXFormFieldKey: @"otherAddress", FXFormFieldKey: @"otherAddress"},
                 ];
    } else {
        NSLog(@"Not Showing other adress field");
        return @[
                 @{FXFormFieldKey: @"hotelName", FXFormFieldOptions: @[@"Allstar Hotel", @"Boyd Hotel", @"Caldrake Hotel", @"Edgeworth Hotel", @"Elk Hotel", @"Galvin Apartments", @"Graystone Hotel", @"Hartland Hotel", @"Hotel Union", @"Jefferson Hotel", @"Mayfair Hotel", @"Mission Hotel", @"Pierre Hotel", @"Pierre Hotel", @"Raman Hotel", @"Royan Hotel", @"Seneca Hotel", @"Vincent Hotel", @"Other"],
                   FXFormFieldCell: [FXFormOptionPickerCell class], FXFormFieldAction: @"changeAddress"
                   },
                 ];
    }

}

/*
- (NSDictionary *)hotelNameField
{
    return @{
             FXFormFieldOptions: @[@"Allstar Hotel", @"Boyd Hotel", @"Caldrake Hotel", @"Edgeworth Hotel", @"Elk Hotel", @"Galvin Apartments", @"Graystone Hotel", @"Hartland Hotel", @"Hotel Union", @"Jefferson Hotel", @"Mayfair Hotel", @"Mission Hotel", @"Pierre Hotel", @"Pierre Hotel", @"Raman Hotel", @"Royan Hotel", @"Seneca Hotel", @"Vincent Hotel", @"Other"],
             FXFormFieldCell: [FXFormOptionPickerCell class],
             };
}
 */


- (NSArray *)excludedFields {
    if (!self.showOtherAddress) {
        return @[
                 @"otherAddress",
                 @"showOtherAddress",
                 ];
    } else {
        return @[
                 @"showOtherAddress",
                 ];
    }

}
@end
