//
//  SimpleTextParams.m
//  CoreTextView_Lab0
//
//  Created by Xu Deheng on 12-1-10.
//  Copyright (c) 2012年 北京易天新动网络科技有限公司. All rights reserved.
//

#import "SimpleTextParams.h"

@implementation SimpleTextParams

@synthesize foregroundColor;
@synthesize backgroundColor;
@synthesize uiFont;
@synthesize fontName;
@synthesize fontSize;
@synthesize lineSpace;
@synthesize lineHeight;
@synthesize charSpace;
@synthesize visibleBounds;

- (id)init
{
    self = [super init];
    if (self) {
        foregroundColor = [UIColor blackColor];
        backgroundColor = [UIColor whiteColor];
        fontSize = 11.0;
        lineSpace = 0.0;
        fontName = @"Helvetica";//Helvetica Arial
        visibleBounds = CGRectZero;
        [self update];
    }
    return self;
}

- (void)dealloc
{
    [foregroundColor release];
    [super dealloc];
}

- (void)update
{
    lineHeight = fontSize + lineSpace;
    self.uiFont = [UIFont fontWithName:fontName size:fontSize];
}

- (UIFont *)fontWithSize:(CGFloat)size
{
    fontSize = size;
    return [UIFont fontWithName:fontName size:fontSize];
}

- (UIFont *)font
{
    return [UIFont fontWithName:fontName size:fontSize];
}

@end
