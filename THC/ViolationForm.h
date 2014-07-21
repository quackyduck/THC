//
//  ViolationForm.h
//  THC
//
//  Created by Hunaid Hussain on 7/20/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViolationForm : NSObject

@property (strong, nonatomic)   NSString   *name;
@property (strong, nonatomic)   NSString   *email;
@property (strong, nonatomic)   NSString   *unit;
@property (strong, nonatomic)   NSString   *phone;
@property (strong, nonatomic)   NSArray    *hotelList;
@property (strong, nonatomic)   NSString   *selectedHotel;
@property (strong, nonatomic)   NSArray    *languages;
@property (strong, nonatomic)   NSString   *languageSpoken;
@property (strong, nonatomic)   NSString   *violationDescription;
@property (strong, nonatomic)   NSString   *caseSummary;

@end
