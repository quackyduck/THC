//
//  PhotoTag.h
//  THC
//
//  Created by Hunaid Hussain on 8/2/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EBPhotoTagProtocol.h"

@interface PhotoTag : NSObject <EBPhotoTagProtocol>

+ (instancetype)tagWithProperties:(NSDictionary*)tagInfo;
- (id)initWithProperties:(NSDictionary *)tagInfo;

@property (assign) CGPoint tagPosition;
@property (strong) NSAttributedString *attributedText;
@property (strong) NSString *text;
@property (strong) NSDictionary *metaData;

@end
