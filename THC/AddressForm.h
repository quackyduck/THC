//
//  AddressForm.h
//  THC
//
//  Created by Hunaid Hussain on 7/6/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"
#import "OtherAddress.h"


@interface AddressForm : NSObject <FXForm>

@property (strong, nonatomic) NSString       *hotelName;
@property (strong, nonatomic) OtherAddress   *otherAddress;
@property (assign)            BOOL           showOtherAddress;
@property (strong, nonatomic) NSMutableArray *hotelBuildingNames;
@property (strong, nonatomic) NSMutableDictionary  *hotelBuildings;

@end
