//
//  CoreTextHelper.h
//  CoreTextView_Lab0
//
//  Created by Xu Deheng on 12-1-5.
//  Copyright (c) 2012年 北京易天新动网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreTextHelper : NSObject

+ (CoreTextHelper*)sharedInstance;
//- (CTFontRef)CreateItalicCTFontByName:(CFStringRef)theFontName;
//- (CTFontRef)CreateBoldCTFontByName:(CFStringRef)theFontName;
//- (CTFontRef)CreateNormalCTFontByName:(CFStringRef)theFontName;

- (NSString*)italicFontNameByString:(NSString*)theFontName;
- (NSString*)boldFontNameByString:(NSString*)theFontName;
- (NSString*)normalFontNameByString:(NSString*)theFontName;


@end
