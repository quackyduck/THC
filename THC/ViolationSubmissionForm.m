//
//  ViolationSubmissionForm.m
//  THC
//
//  Created by Hunaid Hussain on 7/6/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "ViolationSubmissionForm.h"
#import "AddressForm.h"
#import "PhotoInfo.h"
#import "Building.h"


#define kFirstName   @{FXFormFieldKey: @"firstName", FXFormFieldTitle:@"First Name:", FXFormFieldHeader: @"Tell us about yourself", @"textField.autocapitalizationType": @(UITextAutocapitalizationTypeWords)}
#define kLastName    @{FXFormFieldKey: @"lastName", FXFormFieldTitle:@"Last Name:", @"textField.autocapitalizationType": @(UITextAutocapitalizationTypeWords)}
#define kUnit        @{FXFormFieldKey: @"unitNum", FXFormFieldTitle:@"Unit Number:"}
#define kAddress     @{FXFormFieldKey: @"addressForm", FXFormFieldTitle:@"Your Address", FXFormFieldInline: @YES, }
#define kPhone       @{FXFormFieldKey: @"phoneNumber", FXFormFieldTitle:@"Phone Number:", FXFormFieldHeader: @"Your Contact Information", FXFormFieldTitle: @"Phone", FXFormFieldType: FXFormFieldTypeNumber}
#define kEmail       @{FXFormFieldKey: @"email", FXFormFieldTitle:@"Email:"}
#define kLanguages   @{FXFormFieldKey: @"languagesSpoken", FXFormFieldTitle:@"Languages Spoken:", FXFormFieldHeader: @"Your Language", FXFormFieldOptions: @[@"English", @"Spanish", @"Chinese", @"Cantonese", @"Vietnamese", @"Fillipino", @"Punjabi", @"Hindi", @"Korean", @"Malay", @"Other"], FXFormFieldCell: [FXFormOptionPickerCell class], FXFormFieldAction: @"addOtherLanguage:"}
#define kOtherLang   @{FXFormFieldKey: @"otherLanguage", FXFormFieldTitle:@"Other Language:"}
#define kDescription @{FXFormFieldKey: @"description", FXFormFieldTitle:@"", FXFormFieldHeader: @"Describe the Violation:", FXFormFieldType: FXFormFieldTypeLongText}

#define kSubmit      @{FXFormFieldTitle: @"Submit", FXFormFieldHeader: @"", FXFormFieldHeader: @"", FXFormFieldAction: @"submitViolationSubmissionForm:"}

@implementation ViolationSubmissionForm

- (id)init
{
    if ((self = [super init]))
    {
        
    }
    return self;
}

- (NSArray *)fields
{
    
    NSArray *fieldsArray;
    if (!self.showOtherLanguage) {
        fieldsArray = [NSArray arrayWithObjects:kFirstName, kLastName, kUnit, kAddress, kPhone, kEmail, kLanguages, kDescription, nil];
    } else {
        fieldsArray = [NSArray arrayWithObjects:kFirstName, kLastName, kUnit, kAddress, kPhone, kEmail, kLanguages, kOtherLang, kDescription, nil];
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

- (void)updateCase:(Case *) myCase {
    
    Building *building = self.addressForm.hotelBuildings[self.addressForm.hotelName];
    
    if (building) {
        myCase.buildingId = building.objectId;
        myCase.address = building.streetAddress;
    } else {
        myCase.address = self.addressForm.otherAddress.streetName;
    }
    myCase.unit = self.unitNum;
    myCase.phoneNumber = self.phoneNumber;
    myCase.email = self.email;
    myCase.languageSpoken = self.languagesSpoken;
    
    [myCase saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [[[UIAlertView alloc] initWithTitle:@"Case Updated" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        } else if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Could not update case" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        }
    }];
}

- (Case*)createCaseWithDescription:(NSString *) description andImageData:(NSData *) imageData completion:(void (^)(Case* newCase))completion error:(void (^)(NSError*))onError {

    
    NSString *userId = nil;
    if ([PFUser currentUser]) {
        userId = [[PFUser currentUser] objectId];
    }
    
//    PFQuery *query = [PFQuery queryWithClassName:@"Building"];
//    [query whereKey:@"buildingName" equalTo:self.addressForm.hotelName];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *buildings, NSError *error) {
//        if (!error) {
//            // The find succeeded.
//            if (buildings.count > 1 || buildings.count == 0) {
//                NSLog(@"Error: Could not find any Hotel with name %@", self.addressForm.hotelName);
//                return;
//            }
//            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)buildings.count);
//            // Do something with the found objects
//            for (PFObject *building in buildings) {
//                NSLog(@"%@", building);
//            }
//        } else {
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];

    Case* newCase = [Case object];
    
    NSLog(@"case id %@", newCase.objectId);
    PhotoInfo* photoInfo = [PhotoInfo object];
    photoInfo.caseId = newCase.objectId;
    photoInfo.caption = nil;
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    photoInfo.image = imageFile;
    
    Building *building = self.addressForm.hotelBuildings[self.addressForm.hotelName];
    
    if (building) {
        newCase.buildingId = building.objectId;
        newCase.address = building.streetAddress;
    } else {
        newCase.address = self.addressForm.otherAddress.streetName;
    }
    newCase.name = [NSString stringWithFormat:@"%@, %@", self.lastName, self.firstName];
    newCase.caseId = newCase.objectId;
    newCase.unit = self.unitNum;
    newCase.phoneNumber = self.phoneNumber;
    newCase.email = self.email;
    newCase.languageSpoken = self.languagesSpoken;
    newCase.description = self.description;
    newCase.userId = userId;
    newCase.status = caseOpen;
    
    
    [newCase saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            photoInfo.caseId = newCase.objectId;
            newCase.caseId = newCase.objectId;
            newCase.status = caseOpen;
            [photoInfo saveInBackgroundWithBlock:^(BOOL caseSuccess, NSError *caseError) {
                if (caseSuccess) {
                    newCase.caseId = photoInfo.objectId;
                    [newCase saveInBackgroundWithBlock:^(BOOL updateSucceeded, NSError *caseUpdateError) {
                        if (updateSucceeded) {
                            completion(newCase);
                        } else
                        {
                            onError(caseUpdateError);
                        }
                    }];
                } else if (caseError) {
                    [[[UIAlertView alloc] initWithTitle:@"Could not Submit the Case" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
                    
                }
                
            }];
        } else if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Could not Submit the Photo" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        }
    }];
    return newCase;
    
}

- (Case*)createCaseWithDescription:(NSString *) description andImageDataList:(NSArray *) imageDataList completion:(void (^)(Case* newCase))completion error:(void (^)(NSError*))onError {
    
    
    NSString *userId = nil;
    if ([PFUser currentUser]) {
        userId = [[PFUser currentUser] objectId];
    }
    
    
    Case* newCase = [Case object];
    
    NSLog(@"case id %@", newCase.objectId);
    PhotoInfo* photoInfo = [PhotoInfo object];
    photoInfo.caseId = newCase.objectId;
    photoInfo.caption = nil;
    int imageIndex = 0;
    NSMutableArray *pFFileList = [NSMutableArray array];
    for (NSData *imageData in  imageDataList) {
        PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"Image_%d", imageIndex] data:imageData];
        [pFFileList addObject:imageFile];
    }
    
//    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
//    photoInfo.image = imageFile;
    
    Building *building = self.addressForm.hotelBuildings[self.addressForm.hotelName];
    
    if (building) {
        newCase.buildingId = building.objectId;
        newCase.address = building.streetAddress;
    } else {
        newCase.address = self.addressForm.otherAddress.streetName;
    }
    newCase.name = [NSString stringWithFormat:@"%@, %@", self.lastName, self.firstName];
    newCase.caseId = newCase.objectId;
    newCase.unit = self.unitNum;
    newCase.phoneNumber = self.phoneNumber;
    newCase.email = self.email;
    newCase.languageSpoken = self.languagesSpoken;
    newCase.description = self.description;
    newCase.userId = userId;
    newCase.status = caseOpen;
    
    
    [newCase saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            photoInfo.caseId = newCase.objectId;
            newCase.caseId = newCase.objectId;
            newCase.status = caseOpen;
            [photoInfo saveInBackgroundWithBlock:^(BOOL caseSuccess, NSError *caseError) {
                if (caseSuccess) {
                    newCase.caseId = photoInfo.objectId;
                    [newCase saveInBackgroundWithBlock:^(BOOL updateSucceeded, NSError *caseUpdateError) {
                        if (updateSucceeded) {
                            completion(newCase);
                        } else
                        {
                            onError(caseUpdateError);
                        }
                    }];
                } else if (caseError) {
                    [[[UIAlertView alloc] initWithTitle:@"Could not Submit the Case" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
                    
                }
                
            }];
        } else if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Could not Submit the Photo" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        }
    }];
    return newCase;
    
}


- (Case*)createCaseWithDescription:(NSString *) description withImageDataList:(NSArray *) imageDataList completion:(void (^)(Case* newCase))completion error:(void (^)(NSError*))onError {
    
    
    NSString *userId = nil;
    if ([PFUser currentUser]) {
        userId = [[PFUser currentUser] objectId];
    }
    
    
    Case* newCase = [Case object];
    
    NSLog(@"case id %@", newCase.objectId);
    
    Building *building = self.addressForm.hotelBuildings[self.addressForm.hotelName];
    
    if (building) {
        newCase.buildingId = building.objectId;
        newCase.address = building.streetAddress;
    } else {
        newCase.address = self.addressForm.otherAddress.streetName;
    }
    newCase.name = [NSString stringWithFormat:@"%@, %@", self.lastName, self.firstName];
    newCase.caseId = newCase.objectId;
    newCase.unit = self.unitNum;
    newCase.phoneNumber = self.phoneNumber;
    newCase.email = self.email;
    newCase.languageSpoken = self.languagesSpoken;
    newCase.description = self.description;
    newCase.userId = userId;
    newCase.status = caseOpen;
    
    
    [newCase saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            
            NSMutableArray *photoObjectList = [NSMutableArray array];
            
            NSUInteger imageIndex = 1;
            for (NSData *imageData in  imageDataList) {
                PhotoInfo* photoInfo = [PhotoInfo object];
                photoInfo.caseId = newCase.objectId;
                photoInfo.caption = nil;
                PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"Image_%lu", (unsigned long)imageIndex] data:imageData];
                photoInfo.image = imageFile;
                photoInfo.caseId = newCase.objectId;
                
                [photoObjectList addObject:photoInfo];
                
                 ++imageIndex;

            }
            
            
            newCase.status = caseOpen;
            [PFObject saveAllInBackground:photoObjectList block:^(BOOL photoSuccess, NSError *photoError) {
                if (photoSuccess) {
                    NSMutableArray *photoIdList = [NSMutableArray array];
                    for (PhotoInfo *photoInfo in photoObjectList) {
                        [photoIdList addObject:photoInfo.objectId];
                        newCase.caseId = photoInfo.objectId;

                    }
                    newCase.photoIdList = photoIdList;
                    NSLog(@"submitting case with %lu photos", (unsigned long)[photoIdList count]);
//                    newCase.caseId = photoInfo.objectId;
                    [newCase saveInBackgroundWithBlock:^(BOOL updateSucceeded, NSError *caseUpdateError) {
                        if (updateSucceeded) {
                            completion(newCase);
                        } else
                        {
                            onError(caseUpdateError);
                        }
                    }];
                } else if (photoError) {
                    [[[UIAlertView alloc] initWithTitle:@"Could not Submit the Case" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
                    
                }

            }];
            

        } else if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Could not Submit the Photo" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        }
    }];
    return newCase;
    
}

@end
