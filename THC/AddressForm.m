//
//  AddressForm.m
//  THC
//
//  Created by Hunaid Hussain on 7/6/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "AddressForm.h"
#import "Building.h"

#define kHotel            @{FXFormFieldKey: @"hotelName", FXFormFieldOptions: @[@"Allstar Hotel", @"Boyd Hotel", @"Caldrake Hotel", @"Edgeworth Hotel", @"Elk Hotel", @"Galvin Apartments", @"Graystone Hotel", @"Hartland Hotel", @"Hotel Union", @"Jefferson Hotel", @"Mayfair Hotel", @"Mission Hotel", @"Pierre Hotel", @"Pierre Hotel", @"Raman Hotel", @"Royan Hotel", @"Seneca Hotel", @"Vincent Hotel", @"Other"], FXFormFieldCell: [FXFormOptionPickerCell class], FXFormFieldAction: @"changeAddress"}
#define kHotelFromParse   @{FXFormFieldKey: @"hotelName", FXFormFieldOptions: self.hotelBuildingNames, FXFormFieldCell: [FXFormOptionPickerCell class], FXFormFieldAction: @"changeAddress"}
#define kOtherAddress     @{FXFormFieldKey: @"otherAddress", FXFormFieldKey: @"otherAddress"}


@implementation AddressForm

- (id)init
{
    if ((self = [super init]))
    {
        self.hotelBuildingNames = [NSMutableArray array];
        self.hotelBuildings     = [NSMutableDictionary dictionary];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Building"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *buildings, NSError *error) {
            if (!error) {
                for (Building *building in buildings) {
                    [self.hotelBuildingNames addObject:building.buildingName];
                    self.hotelBuildings[building.buildingName] = building;
                }
                [self.hotelBuildingNames addObject:@"Other"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Addresses Retrieved" object:self];

            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
    return self;
}

- (NSArray *)fields
{
    NSMutableArray *fieldsArray;
    if (self.showOtherAddress) {
        
        if (![self.hotelBuildingNames count]) {
            fieldsArray = [NSMutableArray arrayWithObjects:kHotel, kOtherAddress, nil];
            return fieldsArray;
        }
        fieldsArray  = [NSMutableArray arrayWithObjects:kHotelFromParse, kOtherAddress, nil];
        
//        fieldsArray = [NSArray arrayWithObjects:kHotel, kOtherAddress, nil];
    } else {
        //NSLog(@"1. hotel buildings %@", self.hotelBuildingNames);
        if (![self.hotelBuildingNames count]) {
            fieldsArray = [NSMutableArray arrayWithObjects:kHotel, nil];
            return fieldsArray;
        }
        fieldsArray  = [NSMutableArray arrayWithObjects:kHotelFromParse, nil];

//        fieldsArray = [NSArray arrayWithObjects:kHotel, nil];
    }
    return fieldsArray;
    
}
@end
