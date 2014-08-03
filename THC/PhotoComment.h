//
//  PhotoComment.h
//  THC
//
//  Created by Hunaid Hussain on 8/2/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EBPhotoCommentProtocol.h"

@interface PhotoComment : NSObject <EBPhotoCommentProtocol>

+ (instancetype)commentWithProperties:(NSDictionary*)commentInfo;
- (id)initWithProperties:(NSDictionary *)commentInfo;

@property (assign, getter=isUserCreated) BOOL userCreated;
@property (strong) NSAttributedString *attributedText;
@property (strong) NSString *text;
@property (strong) NSDate *date;
@property (strong) NSString *name;
@property (strong) UIImage *image;
@property (strong) NSDictionary *metaData;

@end
