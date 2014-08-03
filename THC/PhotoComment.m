//
//  PhotoComment.m
//  THC
//
//  Created by Hunaid Hussain on 8/2/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "PhotoComment.h"

@implementation PhotoComment

+ (instancetype)commentWithProperties:(NSDictionary*)commentInfo
{
    return [[PhotoComment alloc] initWithProperties:commentInfo];
}

- (id)initWithProperties:(NSDictionary *)commentInfo
{
    self = [super init];
    if (self) {
        [self setText:commentInfo[@"commentText"]];
        [self setAttributedText:commentInfo[@"attributedCommentText"]];
        [self setDate:commentInfo[@"commentDate"]];
        [self setName:commentInfo[@"authorName"]];
        [self setImage:commentInfo[@"authorImage"]];
        [self setMetaData:commentInfo[@"metaData"]];
    }
    return self;
}

- (NSAttributedString *)attributedCommentText
{
    return self.attributedText;
}

- (NSString *)commentText
{
    return self.text;
}

//This is the date when the comment was posted.
- (NSDate *)postDate
{
    return self.date;
}

//This is the name that will be displayed for whoever posted the comment.
- (NSString *)authorName
{
    return self.name;
}

//This is an image of the person who posted the comment
- (UIImage *)authorAvatar
{
    return self.image;
}

@end
