//
//  ViolationForm.h
//  THC
//
//  Created by Hunaid Hussain on 7/20/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FieldContent.h"
#import "Case.h"

@interface ViolationForm : NSObject <FieldContent>

@property (strong, nonatomic)   NSString   *name;
@property (strong, nonatomic)   NSString   *email;
@property (strong, nonatomic)   NSString   *unit;
@property (strong, nonatomic)   NSString   *phone;
@property (strong, nonatomic)   NSArray    *hotelList;
@property (strong, nonatomic)   NSString   *selectedHotel;
@property (strong, nonatomic)   NSArray    *languages;
@property (strong, nonatomic)   NSString   *languageSpoken;
@property (strong, nonatomic)   NSString   *violationDescription;
@property (strong, nonatomic)   NSString   *violationType;
@property (strong, nonatomic)   NSString   *multiUnitPetiiton;
@property (strong, nonatomic)   NSMutableArray *hotelBuildingNames;
@property (strong, nonatomic)   NSMutableDictionary *hotelBuildings;
@property (strong, nonatomic)   Case                *caseInfo;


- (void)setValue:(NSString *)value forField:(NSString *)field;
- (NSString *)getValueForField:(NSString *)field;

- (void)setCase:(Case*) caseInfo;

- (BOOL)addloggedInUserDetails;

- (NSString *)computeHotelDistancesFromLocation:(CLLocation*)userLocation;
- (void)populateHotelsWithSuccess:(void (^)(BOOL success))completion error:(void (^)(NSError*))onError;

- (void)assignNearestHotel;

- (void)dumpFormContent;

- (Case*)createCaseWithDescription:(NSString *) description withImageDataList:(NSArray *) imageDataList completion:(void (^)(Case* newCase))completion error:(void (^)(NSError*))onError;
// This call takes image orientation
- (Case*)createCaseWithDescription:(NSString *) description withImageDataList:(NSArray *) imageDataList withOrientation:(NSArray *)orientations completion:(void (^)(Case* newCase))completion error:(void (^)(NSError*))onError;


@end
