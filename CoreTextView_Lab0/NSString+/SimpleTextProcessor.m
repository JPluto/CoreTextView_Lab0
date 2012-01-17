//
//  SimpleTextProcessor.m
//  CoreTextView_Lab0
//
//  Created by Deheng Xu on 11-12-15.
//  Copyright 2011年 北京易天新动网络科技有限公司. All rights reserved.
//

#import "SimpleTextProcessor.h"
#import "SimpleTextParams.h"
#import "TextView.h"

@implementation LineInfo

@synthesize string;
@synthesize range;

+ (id)infoWithRange:(NSRange)aRange andString:(NSString *)aString
{
    LineInfo * info = [LineInfo new];
    info.range = aRange;
    info.string = aString;
    return [info autorelease];
}

- (void)dealloc
{
    [string release];
    [super dealloc];
}

@end

@implementation SimpleTextProcessor

//@synthesize uiFont;
@synthesize pagesInfo;
@synthesize visibleLines;
@synthesize textView;
@synthesize currentPage;
@synthesize text;
@synthesize params;

+ (SimpleTextProcessor *)processorWithParams:(SimpleTextParams *)aParams
{
    SimpleTextProcessor * processor = [SimpleTextProcessor new];
    if (processor) {
        processor.params = aParams;
    }
    return [processor autorelease];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        [self initSimpleTextParams];
    }
    
    return self;
}

- (void)dealloc
{
    [text release];
    [textView release];
    [pagesInfo release];
    [params release];
    [visibleLines release];
    [linesInfo release];
    [super dealloc];
}

- (void)initSimpleTextParams
{    
    CGPoint _textOrig = CGPointMake(10.0, 10.0);
    params.visibleBounds = CGRectMake(_textOrig.x, _textOrig.y, textView.frame.size.width - _textOrig.x * 2, textView.frame.size.height - _textOrig.y * 2);
    
    if (linesInfo == nil) {
        linesInfo = [NSMutableArray new];
    }
    [params update];
    if (pagesInfo == nil) {
        self.pagesInfo = [NSMutableArray array];
    }
    if (params == nil) {
        params = [SimpleTextParams new];
    }
}

- (void)updateParams
{
    [params update];
}

- (void)reloadText
{
    [self textLinesFromRange:NSMakeRange(startGlyphIndex, totalGlyphCount) OfString:text inRect:params.visibleBounds UsingFont:params.uiFont LineBreakMode:UILineBreakModeCharacterWrap IsForward:YES];
}

- (NSArray *)textLinesFromRange:(NSRange)aRange OfString:(NSString *)theString inRect:(CGRect)theRect UsingFont:(UIFont *)theFont LineBreakMode:(UILineBreakMode)lineBreakMode IsForward:(BOOL)isForward
{
    NSString * tmpStr = [theString substringWithRange:aRange];
    NSMutableArray * tmpLines = nil;
    if (params != nil) {
        params.visibleBounds = theRect;
    }
    
    if (isForward) {//正向排版
        startGlyphIndex = aRange.location;
        tmpLines = (NSMutableArray*)[self textLinesFromString:tmpStr inRect:theRect usingFont:theFont lineBreakMode:lineBreakMode];
    }else {//逆向排版(先逆向排版确定可显示的字符范围，再正向将可显示的字符正常排版出来)
        //逆向
        startGlyphIndex = 0;
        tmpLines = (NSMutableArray*)[self textLinesFromReverseString:tmpStr inRect:theRect usingFont:theFont lineBreakMode:lineBreakMode];
        [XUtils printArray:tmpLines];
        //正向
        startGlyphIndex = tmpStr.length - totalGlyphCount + 1;
        tmpStr = [text substringFromIndex:startGlyphIndex];
        tmpLines = (NSMutableArray*)[self textLinesFromString:tmpStr inRect:theRect usingFont:theFont lineBreakMode:lineBreakMode];
        NSUInteger maxLines = [self getMaxLinesCount];
        NSLog(@"max :%u, tmpLines :%u", maxLines, [tmpLines count]);
        tmpLines = [NSMutableArray arrayWithArray:[tmpLines subarrayWithRange:NSMakeRange(tmpLines.count - maxLines, maxLines)]];
    }
    
    self.visibleLines = [NSMutableArray arrayWithArray:tmpLines];
    NSLog(@"%@ startGlyphIndex :%u; totalGlyphCount %u", DEBUG_FUNCTION_NAME, startGlyphIndex, totalGlyphCount);
    return tmpLines;
}

- (NSArray *)textLinesFromString:(NSString *)theString inRect:(CGRect)theRect usingFont:(UIFont *)theFont lineBreakMode:(UILineBreakMode)breakMode
{
    OUT_FUNCTION_NAME();
    NSMutableArray * tmp = [NSMutableArray new];
    CGSize tmpSize;
    [linesInfo removeAllObjects];
    
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
        
        NSString * _getChar = [theString substringWithRange:NSMakeRange(i, 1)];        
        if ([_getChar isEqualToString:@"\r"]) {
            NSLog(@"found \\r");
            if (i == 0) {
                NSLog(@"屏蔽行首的回车");
                i++;
                continue;
            }
        }else if ([_getChar isEqualToString:@"\n"]) {
            NSLog(@"found \\n");
            if (i == 0) {//屏蔽行首的回车
                NSLog(@"屏蔽行首的回车");
                i++;
                continue;
            }
        }else if ([_getChar isEqualToString:@"\t"]) {
            NSLog(@"found \\t");
            [mutableString appendString:@" "];
        }else {
            [mutableString appendString: _getChar];
        }
        tmpSize = [mutableString sizeWithFont:theFont];
        //tmpSize = [mutableString sizeWithFont:theFont constrainedToSize:theRect.size lineBreakMode:breakMode];
        
        NSString * _subStr = nil;
        
        if ([_getChar isEqualToString:@"\n"]) {
            [tmp addObject:mutableString];
            mutableString = [NSMutableString string];
            if (tmp.count * _lineHeight > theRect.size.height) {//整体高度超出显示区域
                //NSLog(@"超出高度 :%@", [tmp lastObject]);
                i -= ((NSString*)tmp.lastObject).length;
                [tmp removeLastObject];
                break;
            }
        }else if (tmpSize.width > theRect.size.width) {
            _subStr = [mutableString substringToIndex:mutableString.length - 1];
            //NSLog(@"回溯  %@  %@  lineHeight :%f    \n_subStr :%@\nmutableString :%@", NSStringFromCGSize(tmpSize), NSStringFromCGSize([_subStr sizeWithFont:theFont]), _lineHeight, _subStr, mutableString);
            [tmp addObject:_subStr];
            mutableString = [NSMutableString string];
            i--;//回溯
            
            if (tmp.count * _lineHeight > theRect.size.height) {//整体高度超出显示区域
                //NSLog(@"超出高度 :%@", [tmp lastObject]);
                i -= ((NSString*)tmp.lastObject).length;
                [tmp removeLastObject];
                break;
            }
        }
        
        if (i >= count - 1) {//遍历到结尾
            [tmp addObject:mutableString];
            if (tmp.count * _lineHeight > theRect.size.height) {//整体高度超出显示区域
                NSLog(@"超出高度 :%@", [tmp lastObject]);
                i -= ((NSString*)tmp.lastObject).length;
                [tmp removeLastObject];
                break;
            }

            mutableString = nil;
            break;
        }
        
    }
    
    totalGlyphCount = i + 1;
    [__pool drain];

    //NSLog(@"count :%d;  totalGlyphCount :%u; i :%d", count, totalGlyphCount, i);

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
        
        NSString * _getChar = [theString substringWithRange:NSMakeRange(i, 1)];

        if ([_getChar isEqualToString:@"\r"]) {
            NSLog(@"found \\r");
        }else if ([_getChar isEqualToString:@"\n"]) {
            NSLog(@"found \\n");
        }else if ([_getChar isEqualToString:@"\t"]) {
            NSLog(@"found \\t");
            [mutableString insertString:@" " atIndex:0];
        }else {
            //往第一个字符处添加字符
            [mutableString insertString:_getChar atIndex:0];
        }
        
        tmpSize = [mutableString sizeWithFont:theFont];
        //tmpSize = [mutableString sizeWithFont:theFont constrainedToSize:theRect.size lineBreakMode:breakMode];
        
        NSString * _subStr = nil;
        if ([_getChar isEqualToString:@"\n"]) {
            _subStr = mutableString;
            [tmp insertObject:_subStr atIndex:0];
            mutableString = [NSMutableString string];
            
            if (tmp.count * _lineHeight >= theRect.size.height) {//整体高度超出显示区域
                NSLog(@"超出高度 :%@", [tmp objectAtIndex:0]);
                i += [[tmp objectAtIndex:0] length];
                [tmp removeObjectAtIndex:0];
                break;
            }            
        }else if (tmpSize.width > theRect.size.width) {
            _subStr = [mutableString substringFromIndex:1];
            //NSLog(@"回溯  %@  %@  %f    \n%@\n%@", NSStringFromCGSize(tmpSize), NSStringFromCGSize([_subStr sizeWithFont:theFont]), _lineHeight, _subStr, mutableString);
            [tmp insertObject:_subStr atIndex:0];
            mutableString = [NSMutableString string];
            i++;//回溯
            
//            if (tmp.count * _lineHeight > theRect.size.height) {//整体高度超出显示区域
//                //NSLog(@"超出高度 :%@", [tmp objectAtIndex:0]);
//                i += [[tmp objectAtIndex:0] length];
//                [tmp removeObjectAtIndex:0];
//                break;
//            }

        }
        
        if (i <= 0) {
            [tmp insertObject:[mutableString substringFromIndex:1] atIndex:0];
            if (tmp.count * _lineHeight > theRect.size.height) {//整体高度超出显示区域
                //NSLog(@"超出高度 :%@", [tmp objectAtIndex:0]);
                i += [[tmp objectAtIndex:0] length];
                [tmp removeObjectAtIndex:0];
                break;
            }
            NSLog(@"搜索到开头!");
            mutableString = nil;
            break;
        }
        

    }
    [__pool drain];
    totalGlyphCount = count - 1 - i + 1;
    //NSLog(@"count :%d;  totalGlyphCount :%u; i :%d", count, totalGlyphCount, i);
    
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
    lines = (NSMutableArray*)[self textLinesFromRange:NSMakeRange(0, text.length) OfString:text inRect:theRect UsingFont:params.uiFont LineBreakMode:UILineBreakModeCharacterWrap IsForward:YES];
    if (lines != nil) {
        nsRange = NSMakeRange(startGlyphIndex, totalGlyphCount);
        rangeValue = [NSValue valueWithRange:nsRange];
    }

#if DEBUG_SHOW_TIME_ELAPSE
    NSDate * date = [NSDate date];
#endif
    while (lines != nil && text.length > startGlyphIndex + totalGlyphCount) {
        [pagesInfo addObject:rangeValue];
        lines = (NSMutableArray*)[self textLinesFromRange:NSMakeRange(startGlyphIndex + totalGlyphCount, text.length) OfString:text inRect:theRect UsingFont:params.uiFont LineBreakMode:UILineBreakModeCharacterWrap IsForward:YES]; 
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
    //OUT_FUNCTION_NAME();
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
    [self textLinesFromRange:range OfString:text inRect:theFrame UsingFont:params.uiFont LineBreakMode:UILineBreakModeCharacterWrap IsForward:YES];
}

- (void)loadCurrentPageInFrame:(CGRect)theRect
{
    [self loadPage:currentPage InFrame:theRect];
}

- (void)loadNextPage
{
    NSLog(@"%@ ", DEBUG_FUNCTION_NAME);
    if (startGlyphIndex + totalGlyphCount + 1 >= text.length || startGlyphIndex >= NSNotFound) {
        return;
    }
    startGlyphIndex += totalGlyphCount;
    [self textLinesFromRange:NSMakeRange(startGlyphIndex, self.text.length - startGlyphIndex) OfString:text inRect:params.visibleBounds UsingFont:params.uiFont LineBreakMode:UILineBreakModeCharacterWrap IsForward:YES];
}

- (void)loadPrevPage
{
    NSLog(@"%@ ", DEBUG_FUNCTION_NAME);
    if (startGlyphIndex == 0 || startGlyphIndex >= NSNotFound) {
        return;
    }
    NSUInteger endIndex = startGlyphIndex;
    startGlyphIndex = 0;
    //NSLog(@"%@", [text substringWithRange:NSMakeRange(startGlyphIndex, endIndex)]);
    [self textLinesFromRange:NSMakeRange(startGlyphIndex, endIndex) OfString:text inRect:params.visibleBounds UsingFont:params.uiFont LineBreakMode:UILineBreakModeCharacterWrap IsForward:NO];
}

- (NSUInteger)getMaxLinesCount
{
    return params.visibleBounds.size.height / params.lineHeight;
}

@end
