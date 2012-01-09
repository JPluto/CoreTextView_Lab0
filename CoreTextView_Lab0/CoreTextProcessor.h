//
//  CoreTextSetting.h
//  CoreTextView_Lab0
//
//  Created by Xu Deheng on 12-1-5.
//  Copyright (c) 2012年 北京易天新动网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CoreTextParams;
@class CoreTextHelper;
@class CoreTextView;

@interface CoreTextProcessor : NSObject {
@public
    CTFrameRef visibleFrameRef;//可见区域
    CTFramesetterRef framesetterRef;//framesetter
    CFAttributedStringRef attributedStringRef;//属性化文本
    CFRange visibleRange;//可见区域文本范围
    CFIndex startGlyphIndex;//可见区域文本起始下标
    CFIndex totalGlyphCount;//可见区域文本文字数
    CFArrayRef visibleLines;//可见区域文本行
    NSMutableArray * pagesInfo;
    NSUInteger currentPage;
}

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) UIColor *foregroundColor;
@property (nonatomic, retain) UIColor *backgroundColor;
@property (nonatomic, retain) UIImage *backgroundImage;
@property (nonatomic, retain) CoreTextParams *coreTextParams;
@property (nonatomic, retain) CoreTextHelper *coreTextHelper;
@property (nonatomic, assign) CoreTextView *coreTextView;
@property (nonatomic, retain) NSMutableArray * pagesInfo;
@property (nonatomic, assign) NSUInteger currentPage;

- (void)initCoreTextParams;

- (void)loadFile:(NSString*)filePath;
- (void)loadText:(NSString*)aString;
- (void)loadVisibleTextForCFRange:(CFRange)rang;
- (void)loadAllPages;
- (void)loadPage:(NSUInteger)page;
- (void)loadCurrentPage;


@end
