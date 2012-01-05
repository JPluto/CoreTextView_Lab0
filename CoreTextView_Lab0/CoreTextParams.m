//
//  CoreTextParams.m
//  CoreTextView_Lab0
//
//  Created by Xu Deheng on 12-1-5.
//  Copyright (c) 2012年 北京易天新动网络科技有限公司. All rights reserved.
//

#import "CoreTextParams.h"

@implementation CoreTextParams

@synthesize fontName;
@synthesize foregroundColor;
@synthesize backgroundColor;
@synthesize backgroundImageView;

- (id)init
{
    self = [super init];
    if (self) {
        fontSize = 18.0f;
        lineSpace = 0.0f;
        lineHeight = fontSize + lineSpace;
        fontName = @"Arial";
    }
    return self;
}

- (void)dealloc
{
    if (fontRef != NULL) {
        CFRelease(fontRef);
    }
    [fontName release];
    [foregroundColor release];
    [backgroundColor release];
    [backgroundImageView release];
    [super dealloc];
}

@end
