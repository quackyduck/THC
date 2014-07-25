//
//  FieldContent.h
//  THC
//
//  Created by Hunaid Hussain on 7/21/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FieldContent <NSObject>

- (void)setValue:(NSString *)value forField:(NSString *)field;

@optional
- (NSString *)getValueForField:(NSString *)field;

@end
