//
//  ViolationForm.m
//  THC
//
//  Created by Hunaid Hussain on 7/20/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "ViolationForm.h"
#import "PhotoInfo.h"
#import "Building.h"

#define languageList @{@"English", @"Spanish", @"Chinese", @"Mandarin", @"Vietnami", @"Phillipino", nil}
#define FieldList    @[@"name", @"languageSpoken", @"hotel", @"address", @"email", @"phone", @"violationDescription"]

@interface ViolationForm ()

@property (strong, nonatomic) NSMutableDictionary *streetAddress;

@end

@implementation ViolationForm

- (id)init
{
    if ((self = [super init]))
    {
        self.hotelBuildingNames = [NSMutableArray array];
        self.hotelBuildings     = [NSMutableDictionary dictionary];
        self.streetAddress      = [NSMutableDictionary dictionary];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Building"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *buildings, NSError *error) {
            if (!error) {
                for (Building *building in buildings) {
                    [self.hotelBuildingNames addObject:building.buildingName];
                    self.hotelBuildings[building.buildingName] = building;
                    self.streetAddress[building.streetAddress] = building.buildingName;
                }
//                NSLog(@"street address %@", self.streetAddress);
                [self.hotelBuildingNames addObject:@"Other"];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"Addresses Retrieved" object:self];
                
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
    return self;
}

- (BOOL)addloggedInUserDetails {
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        if ([currentUser.username isEqualToString:@"hunaid@hotmail.com"]) {
            self.name = @"Hunaid Hussain";
        } else if ([currentUser.username isEqualToString:@"melo.nicolas@gmail.com"]) {
            self.name = @"Nicolas Melo";
        } else if ([currentUser.username isEqualToString:@"rosejonescolour@yahoo.com"]) {
            self.name = @"Rose Jones";
        } else if ([currentUser.username isEqualToString:@"test@gmail.com"]) {
            self.name = @"Test Bot";
        } else {
            self.name = currentUser.username;
        }
        
        self.email = currentUser.email;
        return YES;
    }
    return NO;
}

- (void)setCase:(Case*) caseInfo {
    self.caseInfo              = caseInfo;
    self.name                  = caseInfo.name;
    self.email                 = caseInfo.email;
    self.phone                 = caseInfo.phoneNumber;
    self.selectedHotel         = self.streetAddress[caseInfo.address];
    self.unit                  = caseInfo.unit;
    self.languageSpoken        = caseInfo.languageSpoken;
    self.violationDescription  = caseInfo.violationDetails;
    self.violationType         = caseInfo.violationType;
    self.multiUnitPetiiton     = caseInfo.multiUnitPetition ? @"YES" : @"NO";
    
//    NSLog(@"case description %@", caseInfo.description);
//    NSLog(@"self.streetAddress %@", self.streetAddress);
//    NSLog(@"case address %@", caseInfo.address);
    
    if (caseInfo.address) {
        PFQuery *query = [PFQuery queryWithClassName:@"Building"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *buildings, NSError *error) {
            if (!error) {
                for (Building *building in buildings) {
                    [self.hotelBuildingNames addObject:building.buildingName];
                    self.hotelBuildings[building.buildingName] = building;
                    self.streetAddress[building.streetAddress] = building.buildingName;
                }
//                NSLog(@"street address %@", self.streetAddress);
                self.selectedHotel = self.streetAddress[caseInfo.address];
                [self.hotelBuildingNames addObject:@"Other"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Addresses Retrieved" object:self];
                
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }

//    [self dumpFormContent];
}

- (void)setValue:(NSString *)value forField:(NSString *)field {
    if ([field isEqualToString:@"name"]) {
        self.name = value;
    } else if ([field isEqualToString:@"email"]) {
        self.email = value;
    } else if ([field isEqualToString:@"unit"]) {
            self.unit = value;
    } else if ([field isEqualToString:@"phone"]) {
        self.phone = value;
    } else if ([field isEqualToString:@"selectedHotel"]) {
        self.selectedHotel = value;
    } else if ([field isEqualToString:@"languageSpoken"]) {
        self.languageSpoken = value;
    } else if ([field isEqualToString:@"violationDescription"]) {
        self.violationDescription = value;
    } else if ([field isEqualToString:@"violationType"]) {
        self.violationType = value;
    } else if ([field isEqualToString:@"multiUnitPetiiton"]) {
        self.multiUnitPetiiton = value;
    }
}

- (NSString *)getValueForField:(NSString *)field {
    
    if ([field isEqualToString:@"name"]) {
        return self.name;
    } else if ([field isEqualToString:@"email"]) {
        return self.email;
    } else if ([field isEqualToString:@"unit"]) {
        return self.unit;
    } else if ([field isEqualToString:@"phone"]) {
        return self.phone;
    } else if ([field isEqualToString:@"selectedHotel"]) {
        return self.selectedHotel;
    } else if ([field isEqualToString:@"languageSpoken"]) {
        return self.languageSpoken;
    } else if ([field isEqualToString:@"violationDescription"]) {
        return self.violationDescription ;
    } else if ([field isEqualToString:@"violationType"]) {
        return self.violationType;
    } else if ([field isEqualToString:@"multiUnitPetiiton"]) {
        return self.multiUnitPetiiton;
    }

    return nil;
}

- (void)dumpFormContent {
    NSLog(@"Name: %@", self.name);
    NSLog(@"Spoken Language: %@", self.languageSpoken);
    NSLog(@"Phone: %@", self.phone);
    NSLog(@"Email: %@", self.email);
    NSLog(@"Hotel: %@", self.selectedHotel);
    NSLog(@"Unit: %@", self.unit);
    NSLog(@"Violation Type: %@", self.violationType);
    NSLog(@"Violation details: %@", self.violationDescription);
}

- (Case*)createCaseWithDescription:(NSString *) description withImageDataList:(NSArray *) imageDataList completion:(void (^)(Case* newCase))completion error:(void (^)(NSError*))onError {
    
    
    NSString *userId = nil;
    if ([PFUser currentUser]) {
        userId = [[PFUser currentUser] objectId];
    }
    
    
    Case* newCase = [Case object];
    
    NSLog(@"case id %@", newCase.objectId);
    
    Building *building = self.hotelBuildings[self.selectedHotel];
    
    if (building) {
        newCase.buildingId = building.objectId;
        newCase.address = building.streetAddress;
    }
    newCase.name = self.name;
    newCase.caseId = newCase.objectId;
    newCase.unit = self.unit;
    newCase.phoneNumber = self.phone;
    newCase.email = self.email;
    newCase.languageSpoken = self.languageSpoken;
    newCase.violationDetails = self.violationDescription;
    NSLog(@"submitting case with description %@", self.violationDescription);
    NSLog(@"submitting case with description %@", newCase.description);
    newCase.multiUnitPetition = [self.multiUnitPetiiton boolValue];
    newCase.userId = userId;
    newCase.status = caseOpen;
    
    if (!imageDataList && [imageDataList count] == 0) {
            [newCase saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"submitted case with violationDetails %@", newCase.violationDetails);
                    completion(newCase);
                } else
                {
                    onError(error);
                }
            }];
    } else {
    
        [newCase saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded) {
                
                NSLog(@"submitted case with violationDetails %@", newCase.violationDetails);

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
    }
    return newCase;
    
}

@end
