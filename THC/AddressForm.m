//
//  AddressForm.m
//  THC
//
//  Created by Hunaid Hussain on 7/6/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "AddressForm.h"

#define kHotel          @{FXFormFieldKey: @"hotelName", FXFormFieldOptions: @[@"Allstar Hotel", @"Boyd Hotel", @"Caldrake Hotel", @"Edgeworth Hotel", @"Elk Hotel", @"Galvin Apartments", @"Graystone Hotel", @"Hartland Hotel", @"Hotel Union", @"Jefferson Hotel", @"Mayfair Hotel", @"Mission Hotel", @"Pierre Hotel", @"Pierre Hotel", @"Raman Hotel", @"Royan Hotel", @"Seneca Hotel", @"Vincent Hotel", @"Other"], FXFormFieldCell: [FXFormOptionPickerCell class], FXFormFieldAction: @"changeAddress"}
#define kOtherAddress   @{FXFormFieldKey: @"otherAddress", FXFormFieldKey: @"otherAddress"}


@implementation AddressForm

- (NSArray *)fields
{
    NSArray *fieldsArray;
    if (self.showOtherAddress) {
        fieldsArray = [NSArray arrayWithObjects:kHotel, kOtherAddress, nil];
    } else {
        fieldsArray = [NSArray arrayWithObjects:kHotel, nil];
    }
    return fieldsArray;
    
    if (self.showOtherAddress) {
        return @[
                 @{FXFormFieldKey: @"hotelName", FXFormFieldOptions: @[@"Allstar Hotel", @"Boyd Hotel", @"Caldrake Hotel", @"Edgeworth Hotel", @"Elk Hotel", @"Galvin Apartments", @"Graystone Hotel", @"Hartland Hotel", @"Hotel Union", @"Jefferson Hotel", @"Mayfair Hotel", @"Mission Hotel", @"Pierre Hotel", @"Pierre Hotel", @"Raman Hotel", @"Royan Hotel", @"Seneca Hotel", @"Vincent Hotel", @"Other"],
                   FXFormFieldCell: [FXFormOptionPickerCell class], FXFormFieldAction: @"changeAddress"
                   },
                 @{FXFormFieldKey: @"otherAddress", FXFormFieldKey: @"otherAddress"},
                 ];
    } else {
        return @[
                 @{FXFormFieldKey: @"hotelName", FXFormFieldOptions: @[@"Allstar Hotel", @"Boyd Hotel", @"Caldrake Hotel", @"Edgeworth Hotel", @"Elk Hotel", @"Galvin Apartments", @"Graystone Hotel", @"Hartland Hotel", @"Hotel Union", @"Jefferson Hotel", @"Mayfair Hotel", @"Mission Hotel", @"Pierre Hotel", @"Pierre Hotel", @"Raman Hotel", @"Royan Hotel", @"Seneca Hotel", @"Vincent Hotel", @"Other"],
                   FXFormFieldCell: [FXFormOptionPickerCell class], FXFormFieldAction: @"changeAddress"
                   },
                 ];
    }

}
@end
