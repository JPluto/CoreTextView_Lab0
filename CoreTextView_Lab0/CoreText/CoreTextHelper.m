//
//  CoreTextHelper.m
//  CoreTextView_Lab0
//
//  Created by Xu Deheng on 12-1-5.
//  Copyright (c) 2012年 北京易天新动网络科技有限公司. All rights reserved.
//

#import "CoreTextHelper.h"

@implementation CoreTextHelper
static CoreTextHelper * __instance = nil;

+ (CoreTextHelper *)sharedInstance
{
    if (__instance == nil) {
        __instance = [[CoreTextHelper alloc] init];
    }
    return __instance;
}

- (id)autorelease
{
    return __instance;
}

- (void)dealloc
{
    [super dealloc];
}

- (NSString *)italicFontNameByString:(NSString *)theFontName
{
    return [NSString stringWithFormat:@"%@-Italic", theFontName];
}

- (NSString *)boldFontNameByString:(NSString *)theFontName
{
    return [NSString stringWithFormat:@"%@-Bold"];
}

- (NSString *)normalFontNameByString:(NSString *)theFontName
{
    return [NSString stringWithFormat:@"%@-Normal"];
}

@end
