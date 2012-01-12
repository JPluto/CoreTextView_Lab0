//
//  SimpleTextProcessor.m
//  CoreTextView_Lab0
//
//  Created by Deheng Xu on 11-12-15.
//  Copyright 2011年 北京易天新动网络科技有限公司. All rights reserved.
//

#import "SimpleTextProcessor.h"
#import "TextView.h"

@implementation SimpleTextProcessor

@synthesize uiFont;
@synthesize pagesInfo;
@synthesize visibleLines;
@synthesize textView;
@synthesize currentPage;
@synthesize text;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
        if (uiFont == nil) {
            self.uiFont = [UIFont systemFontOfSize:fontSize];
        }
        if (pagesInfo == nil) {
            self.pagesInfo = [NSMutableArray array];
        }
    }
    
    return self;
}

- (void)dealloc
{
    [text release];
    [textView release];
    [pagesInfo release];
    [uiFont release];
    [super dealloc];
}

- (void)initSimpleTextParams
{
    fontSize = 15.0f;
    lineSpace = 0.0f;
    lineHeight = fontSize + lineSpace;
}

- (NSArray *)textLinesFromRange:(NSRange)aRange OfString:(NSString *)theString inRect:(CGRect)theRect UsingFont:(UIFont *)theFont LineBreakMode:(UILineBreakMode)lineBreakMode IsForward:(BOOL)isForward
{
    NSString * tmpStr = [theString substringWithRange:aRange];
    NSArray * tmpLines = nil;
    if (isForward) {
        startGlyphIndex = aRange.location;
        tmpLines = [self textLinesFromString:tmpStr inRect:theRect usingFont:theFont lineBreakMode:lineBreakMode];
    }else {
        startGlyphIndex = 0;
        tmpLines = [self textLinesFromReverseString:tmpStr inRect:theRect usingFont:theFont lineBreakMode:lineBreakMode];
        startGlyphIndex = text.length - totalGlyphCount;

        int len = 0;
        for (NSString * tmps in tmpLines) {
            len += [tmps length];
        }
        
        NSLog(@"len :%u", len);
        NSLog(@"string total length :%u;  length :%u", theString.length, text.length);
        NSLog(@"startGlyphIndex :%u; totalGlyphCount :%u;  [%@]", startGlyphIndex, totalGlyphCount, [text substringFromIndex:startGlyphIndex + 1]);


        NSLog(@"startGlyphIndex :%u; %@", startGlyphIndex, [text substringWithRange:NSMakeRange(startGlyphIndex, 1)]);
        tmpStr = [text substringFromIndex:startGlyphIndex];
        tmpLines = [self textLinesFromString:tmpStr inRect:theRect usingFont:theFont lineBreakMode:lineBreakMode];
        NSLog(@"totalGlyphCount :%u, %@", totalGlyphCount, [text substringWithRange:NSMakeRange(startGlyphIndex, 1)]);
    }
    return tmpLines;
}

- (NSArray *)textLinesFromString:(NSString *)theString inRect:(CGRect)theRect usingFont:(UIFont *)theFont lineBreakMode:(UILineBreakMode)breakMode
{
    OUT_FUNCTION_NAME();
    NSMutableArray * tmp = [NSMutableArray new];
    CGSize tmpSize;
    
#if DEBUG_SHOW_TIME_ELAPSE
    NSDate * startDate = [NSDate date];
#endif
    CGFloat _lineHeight = theFont.lineHeight;
    int  i, count = [theString length];
    NSAutoreleasePool * __pool = [NSAutoreleasePool new];
    NSMutableString * mutableString = nil;
    for (i = 0; i < count; i++) {
        if (mutableString == nil) {
            mutableString = [NSMutableString string];
        }
        
        [mutableString appendString: [theString substringWithRange:NSMakeRange(i, 1)]];
        
        tmpSize = [mutableString sizeWithFont:theFont constrainedToSize:theRect.size lineBreakMode:breakMode];
        
        if (tmpSize.height > _lineHeight) {//遍历回溯，出现折行
            [tmp addObject:[mutableString substringToIndex:mutableString.length - 1]];
            mutableString = [NSMutableString string];
            
            if ([tmp count] * _lineHeight > theRect.size.height) {//整体高度超出显示区域
                i -= [[tmp lastObject] length];
                [tmp removeLastObject];
                break;
            }
            
            i--;//回溯            
        }else {
            if (i >= count - 1) {//遍历到结尾
                [tmp addObject:mutableString];
                mutableString = nil;
                break;
            }
        }
    }
    
    //startGlyphIndex += totalGlyphCount;
    totalGlyphCount = i + 1;
    [__pool drain];

    NSLog(@"count :%d;  totalGlyphCount :%u; i :%d", count, totalGlyphCount, i);

#if DEBUG_SHOW_TIME_ELAPSE
    NSDate * endDate = [NSDate date];
    NSLog(@"result :%u  耗时 :%f", tmp.count, ([endDate timeIntervalSince1970] - [startDate timeIntervalSince1970]));
#endif
    
    return [tmp autorelease];
}

- (NSArray *)textLinesFromReverseString:(NSString *)theString inRect:(CGRect)theRect usingFont:(UIFont *)theFont lineBreakMode:(UILineBreakMode)breakMode
{
    OUT_FUNCTION_NAME();
    NSMutableArray * tmp = [NSMutableArray new];
    CGSize tmpSize;
    
#if DEBUG_SHOW_TIME_ELAPSE
    NSDate * startDate = [NSDate date];
#endif
    CGFloat _lineHeight = theFont.lineHeight;
    int  i, count = [theString length];
    NSAutoreleasePool * __pool = [NSAutoreleasePool new];
    NSMutableString * mutableString = nil;
    for (i = count - 1; i >= 0; i--) {
        if (mutableString == nil) {
            mutableString = [NSMutableString string];
        }
        
        //往第一个字符处添加字符
        [mutableString insertString:[theString substringWithRange:NSMakeRange(i, 1)] atIndex:0];
        
        tmpSize = [mutableString sizeWithFont:theFont constrainedToSize:theRect.size lineBreakMode:breakMode];
        
        if (tmpSize.height > _lineHeight) {//遍历回溯，出现折行
            [mutableString deleteCharactersInRange:NSMakeRange(0, 1)];
            [tmp insertObject:mutableString atIndex:0];
            mutableString = [NSMutableString string];
            
            if ([tmp count] * _lineHeight > theRect.size.height) {
                if ([tmp count] > 0) {
                    i += [[tmp objectAtIndex:0] length];
                    [tmp removeObjectAtIndex:0];
                }
                break;
            }
            
            i++;            
        }else {
            if (i <= 0) {
                [tmp insertObject:[mutableString substringFromIndex:1] atIndex:0];
                mutableString = nil;
                break;
            }
        }
        
    }
    [__pool drain];
    totalGlyphCount = count - 1 - i + 1;
    NSLog(@"count :%d;  totalGlyphCount :%u; i :%d", count, totalGlyphCount, i);
    
#if DEBUG_SHOW_TIME_ELAPSE
    NSDate * endDate = [NSDate date];
    NSLog(@"result :%u  耗时 :%f", tmp.count, ([endDate timeIntervalSince1970] - [startDate timeIntervalSince1970]));
#endif
    
    return [tmp autorelease];
}

- (void)loadAllPagesInFrame:(CGRect)theRect
{
    currentPage = 0;
    startGlyphIndex = 0;
    totalGlyphCount = 0;

    self.pagesInfo = [NSMutableArray array];
    NSMutableArray * lines = nil;
    NSValue * rangeValue = nil;
    NSRange nsRange;
    //加载所有页面时，从第一个字符开始正向排版
    lines = (NSMutableArray*)[self textLinesFromRange:NSMakeRange(0, text.length) OfString:text inRect:theRect UsingFont:uiFont LineBreakMode:UILineBreakModeCharacterWrap IsForward:YES];
    if (lines != nil) {
        nsRange = NSMakeRange(startGlyphIndex, totalGlyphCount);
        rangeValue = [NSValue valueWithRange:nsRange];
    }

#if DEBUG_SHOW_TIME_ELAPSE
    NSDate * date = [NSDate date];
#endif
    while (lines != nil && text.length > startGlyphIndex + totalGlyphCount) {
        [pagesInfo addObject:rangeValue];
        lines = (NSMutableArray*)[self textLinesFromRange:NSMakeRange(startGlyphIndex + totalGlyphCount, text.length) OfString:text inRect:theRect UsingFont:uiFont LineBreakMode:UILineBreakModeCharacterWrap IsForward:YES]; 
        if (lines == nil) {
            break;
        }
        nsRange = NSMakeRange(startGlyphIndex, totalGlyphCount);
        rangeValue = [NSValue valueWithRange:nsRange];
    }
#if DEBUG_SHOW_TIME_ELAPSE
    NSDate * endDate = [NSDate date];
    NSLog(@"总共耗时 %f 毫秒； 共 %u 页", ([endDate timeIntervalSince1970] - [date timeIntervalSince1970]), [pagesInfo count]);
#endif
    [self loadCurrentPageInFrame:theRect];
}

-(void)loadText:(NSString *)theString
{
    OUT_FUNCTION_NAME();
    if (theString.length > 0) {
        self.text = [theString stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
    }else {
        return;
    }
}

- (void)loadPage:(NSUInteger)page InFrame:(CGRect)theFrame
{
    if (page >= NSNotFound) {
        return;
    }
    if (page >= [pagesInfo count]) {
        return;
    }
    
    self.currentPage = page;
    NSLog(@"goto page :%u", page);
    NSRange range = [(NSValue*)[pagesInfo objectAtIndex:currentPage] rangeValue];
    NSLog(@"ragne :%@", NSStringFromRange(range));
    //[self loadVisibleTextForCFRange:CFRangeMake(range.location, range.length) InFrame:theRect];
    [self textLinesFromRange:range OfString:text inRect:theFrame UsingFont:self.uiFont LineBreakMode:UILineBreakModeCharacterWrap IsForward:YES];
}

- (void)loadCurrentPageInFrame:(CGRect)theRect
{
    [self loadPage:currentPage InFrame:theRect];
}

@end