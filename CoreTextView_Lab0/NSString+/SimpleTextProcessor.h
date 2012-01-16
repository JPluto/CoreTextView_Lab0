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
@class SimpleTextParams;

typedef struct {
    NSString * line;
    NSUInteger * location;
} LocationChar;

@interface SimpleTextProcessor : NSObject
{
@public
    
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
    //文本参数存储
    SimpleTextParams * params;
}

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSMutableArray * pagesInfo;
@property (nonatomic, retain) NSMutableArray * visibleLines;
@property (nonatomic, assign) TextView * textView;
@property (nonatomic) NSUInteger currentPage;
@property (nonatomic, retain) SimpleTextParams * params;

+ (SimpleTextProcessor*)processorWithParams:(SimpleTextParams*)aParams;
- (void)initSimpleTextParams;
- (void)updateParams;

- (NSArray *)textLinesFromRange:(NSRange)aRange OfString:(NSString*)theString inRect:(CGRect)theRect UsingFont:(UIFont*)theFont LineBreakMode:(UILineBreakMode)lineBreakMode IsForward:(BOOL)isForward;
- (NSArray *) textLinesFromString:(NSString*)theString inRect:(CGRect)theRect usingFont:(UIFont*)theFont lineBreakMode:(UILineBreakMode) breakMode;
- (NSArray *) textLinesFromReverseString:(NSString*)theString inRect:(CGRect)theRect usingFont:(UIFont*)theFont lineBreakMode:(UILineBreakMode) breakMode;

//加载文本
- (void)loadText:(NSString*)theString;
//加载所有页面
- (void)loadAllPagesInFrame:(CGRect)theRect;
//加载对应页面编号
- (void)loadPage:(NSUInteger) pageIndex InFrame:(CGRect)theFrame;
//加载当前页面
- (void)loadCurrentPageInFrame:(CGRect)theRect;
- (void)loadNextPage;
- (void)loadPrevPage;
@end
