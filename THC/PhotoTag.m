//
//  PhotoTag.m
//  THC
//
//  Created by Hunaid Hussain on 8/2/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "PhotoTag.h"

@implementation PhotoTag

+ (instancetype)tagWithProperties:(NSDictionary*)tagInfo
{
    return [[PhotoTag alloc] initWithProperties:tagInfo];
}

- (id)initWithProperties:(NSDictionary *)tagInfo
{
    self = [super init];
    if (self) {
        NSValue *tagPositionValue = tagInfo[@"tagPosition"];
        [self setTagPosition:tagPositionValue.CGPointValue];
        [self setText:tagInfo[@"tagText"]];
        [self setAttributedText:tagInfo[@"attributedTagText"]];
        [self setMetaData:tagInfo[@"metaData"]];
    }
    return self;
}


- (CGPoint)normalizedPosition
{
    return self.tagPosition;
}

- (NSAttributedString *)attributedTagText
{
    return self.attributedText;
}

- (NSString *)tagText
{
    return self.text;
}

- (NSDictionary *)metaInfo
{
    return self.metaData;
}

@end
