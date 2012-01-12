//
//  SimpleTextProcessor.h
//  CoreTextView_Lab0
//
//  Created by Deheng Xu on 11-12-15.
//  Copyright 2011年 北京易天新动网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEBUG_SHOW_TIME_ELAPSE   0

@class TextView;

@interface SimpleTextProcessor : NSObject
{
@public
    //行间距
    CGFloat lineSpace;
    //行高
    CGFloat lineHeight;
    //字间距
    CGFloat charSpace;
    //可视区域
    CGRect visibleBounds;
    //字号
    CGFloat fontSize;
    //UIFont 字体
    UIFont * uiFont;
    //完全分页信息
    NSMutableArray * pagesInfo;
    //当前页起始下标
    NSUInteger startGlyphIndex;
    //当前页总共字符数
    NSUInteger totalGlyphCount;
    //当前页的字符行
    NSMutableArray * visibleLines;
    //当前页号
    NSUInteger currentPage;
    //当前处理的文本
    NSString * text;
}

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) UIFont * uiFont;
@property (nonatomic, retain) NSMutableArray * pagesInfo;
@property (nonatomic, retain) NSMutableArray * visibleLines;
@property (nonatomic, assign) TextView * textView;
@property (nonatomic) NSUInteger currentPage;

- (void)initSimpleTextParams;
- (NSArray *)textLinesFromRange:(NSRange)aRange OfString:(NSString*)theString inRect:(CGRect)theRect UsingFont:(UIFont*)theFont LineBreakMode:(UILineBreakMode)lineBreakMode IsForward:(BOOL)isForward;

- (NSArray *) textLinesFromString:(NSString*)theString inRect:(CGRect)theRect usingFont:(UIFont*)theFont lineBreakMode:(UILineBreakMode) breakMode;

- (NSArray *) textLinesFromReverseString:(NSString*)theString inRect:(CGRect)theRect usingFont:(UIFont*)theFont lineBreakMode:(UILineBreakMode) breakMode;

- (void)loadText:(NSString*)theString;
- (void)loadAllPagesInFrame:(CGRect)theRect;
- (void)loadPage:(NSUInteger) pageIndex InFrame:(CGRect)theFrame;
- (void)loadCurrentPageInFrame:(CGRect)theRect;

@end