//
//  ViolationSubmissionForm.m
//  THC
//
//  Created by Hunaid Hussain on 7/6/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "ViolationSubmissionForm.h"
#import "AddressForm.h"

@implementation ViolationSubmissionForm

- (NSArray *)fields
{
    return @[
                          
             // Personal Info
             @{FXFormFieldKey: @"firstName", FXFormFieldHeader: @"Tell us about yourself", @"textField.autocapitalizationType": @(UITextAutocapitalizationTypeWords)},
             
             @{FXFormFieldKey: @"lastName", @"textField.autocapitalizationType": @(UITextAutocapitalizationTypeWords)},
             
             //we don't need to modify these fields at all, so we'll
             //just refer to them by name to use the default settings
             
             @"unitNum",
             
             //@"addressForm",
             
             @{FXFormFieldKey: @"addressForm", FXFormFieldInline: @YES, },
             
             /*
              @{FXFormFieldKey: @"addressForm",
              FXFormFieldOptions: @[@"Allstar Hotel", @"Boyd Hotel", @"Caldrake Hotel", @"Edgeworth Hotel", @"Elk Hotel", @"Galvin Apartments", @"Graystone Hotel", @"Hartland Hotel", @"Hotel Union", @"Jefferson Hotel", @"Mayfair Hotel", @"Mission Hotel", @"Pierre Hotel", @"Pierre Hotel", @"Raman Hotel", @"Royan Hotel", @"Seneca Hotel", @"Vincent Hotel"],
              FXFormFieldCell: [FXFormOptionPickerCell class]
              },
              */
             
             //@{FXFormFieldKey: @"addressForm"},
             
             //@{FXFormFieldKey: @"phone", FXFormFieldType: FXFormFieldTypeNumber},
             @{FXFormFieldKey: @"phoneNumber", FXFormFieldTitle: @"Phone", FXFormFieldType: FXFormFieldTypeNumber},
             //@"phoneNumber",

             @"email",
             
             @{FXFormFieldKey: @"languagesSpoken",
               FXFormFieldOptions: @[@"English", @"Spanish", @"Chinese", @"Cantonese", @"Vietnamese", @"Fillipino", @"Punjabi", @"Hindi", @"Korean", @"Malay", @"Other"],
               //FXFormFieldTypeDefault: @"English",
               FXFormFieldCell: [FXFormOptionPickerCell class]},
             
             
             //@{FXFormFieldKey: @"notes", FXFormFieldType: FXFormFieldTypeLongText, FXFormFieldHeader: @"Additional Details"},
             
             ];
}

- (NSArray *)extraFields
{
    return @[
             
             @{FXFormFieldTitle: @"Submit", FXFormFieldHeader: @"", FXFormFieldAction: @"submitViolationSubmissionForm:"},
             
             ];
}

- (void)printFormContents {
    
    NSLog(@"First Name: %@, Last Name: %@", self.firstName, self.lastName);
    NSLog(@"Unit Number: %@", self.unitNum);
    if ([self.addressForm.hotelName isEqualToString:@""]) {
        //NSLog(@"Address Other: %@", self.addressForm.other);
    } else {
    NSLog(@"Address: %@", self.addressForm.hotelName);
    }
    NSLog(@"Phone Number: %@", self.phoneNumber);
    NSLog(@"Email: %@", self.email);
    NSLog(@"Language Spoken %@", self.languagesSpoken);
}

@end
