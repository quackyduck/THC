//
//  ViolationSubmissionForm.m
//  THC
//
//  Created by Hunaid Hussain on 7/6/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "ViolationSubmissionForm.h"
#import "AddressForm.h"

#define kFirstName   @{FXFormFieldKey: @"firstName", FXFormFieldTitle:@"First Name:", FXFormFieldHeader: @"Tell us about yourself", @"textField.autocapitalizationType": @(UITextAutocapitalizationTypeWords)}
#define kLastName    @{FXFormFieldKey: @"lastName", FXFormFieldTitle:@"Last Name:", @"textField.autocapitalizationType": @(UITextAutocapitalizationTypeWords)}
#define kUnit        @{FXFormFieldKey: @"unitName", FXFormFieldTitle:@"Unit Number:"}
#define kAddress     @{FXFormFieldKey: @"addressForm", FXFormFieldTitle:@"Your Address", FXFormFieldInline: @YES, }
#define kPhone       @{FXFormFieldKey: @"phoneNumber", FXFormFieldTitle:@"Phone Number:", FXFormFieldHeader: @"Your Contact Information", FXFormFieldTitle: @"Phone", FXFormFieldType: FXFormFieldTypeNumber}
#define kEmail       @{FXFormFieldKey: @"email", FXFormFieldTitle:@"Email:"}
#define kLanguages   @{FXFormFieldKey: @"languagesSpoken", FXFormFieldTitle:@"Languages Spoken:", FXFormFieldHeader: @"Your Language", FXFormFieldOptions: @[@"English", @"Spanish", @"Chinese", @"Cantonese", @"Vietnamese", @"Fillipino", @"Punjabi", @"Hindi", @"Korean", @"Malay", @"Other"], FXFormFieldCell: [FXFormOptionPickerCell class], FXFormFieldAction: @"addOtherLanguage:"}
#define kOtherLang   @{FXFormFieldKey: @"otherLanguage", FXFormFieldTitle:@"Other Language:"}

#define kSubmit      @{FXFormFieldTitle: @"Submit", FXFormFieldHeader: @"", FXFormFieldHeader: @"", FXFormFieldAction: @"submitViolationSubmissionForm:"}

@implementation ViolationSubmissionForm

- (NSArray *)fields
{
    
    NSArray *fieldsArray;
    if (!self.showOtherLanguage) {
        fieldsArray = [NSArray arrayWithObjects:kFirstName, kLastName, kUnit, kAddress, kPhone, kEmail, kLanguages, nil];
    } else {
        fieldsArray = [NSArray arrayWithObjects:kFirstName, kLastName, kUnit, kAddress, kPhone, kEmail, kLanguages, kOtherLang, nil];
    }
    
    return fieldsArray;
 }

- (NSArray *)extraFields
{
    NSArray *extraFieldsArray;
    extraFieldsArray = [NSArray arrayWithObjects:kSubmit, nil];

    return extraFieldsArray;
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
