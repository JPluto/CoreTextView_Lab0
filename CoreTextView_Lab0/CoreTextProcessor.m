//
//  CoreTextSetting.m
//  CoreTextView_Lab0
//
//  Created by Xu Deheng on 12-1-5.
//  Copyright (c) 2012年 北京易天新动网络科技有限公司. All rights reserved.
//

#import "CoreTextProcessor.h"
#import "CoreTextParams.h"
#import "CoreTextHelper.h"
#import "CoreTextView.h"

@implementation CoreTextProcessor

@synthesize text;
@synthesize foregroundColor;
@synthesize backgroundColor;
@synthesize backgroundImage;
@synthesize coreTextParams;
@synthesize coreTextHelper;
@synthesize coreTextView;
@synthesize pagesInfo;
@synthesize currentPage;

CoreTextProcessor * __instance = nil;

+ (CoreTextProcessor *)sharedInstance
{
    if (__instance == nil) {
        __instance = [CoreTextProcessor new];
    }
    __instance.coreTextView = nil;
    return __instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        //init process
        if (coreTextParams == nil) {
            coreTextParams = [CoreTextParams new];
            [coreTextParams updateParams];
            coreTextHelper = [CoreTextHelper new];
        }
        if (pagesInfo == nil) {
            pagesInfo = [NSMutableArray new];
        }
    }
    return self;
}

- (id)autorelease
{
    return self;
}

-(void)dealloc
{
    if (framesetterRef != NULL) {
        CFRelease(framesetterRef);
    }
    if (attributedStringRef != NULL) {
        CFRelease(attributedStringRef);
    }
    [pagesInfo release];
    [foregroundColor release];
    [backgroundColor release];
    [backgroundImage release];
    [super dealloc];
}

- (void)initCoreTextParams
{
    
}

- (void)loadFile:(NSString *)filePath
{
    
}

- (void)loadText:(NSString *)aString
{
    OUT_FUNCTION_NAME();
    NSLog(@"%@", DEBUG_FUNCTION_NAME);
    if (aString.length > 0) {
        self.text = [aString stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
    }else {
        return;
    }
    
    NSMutableAttributedString * attStr = nil;
	//Helvetica Arial
    
    //config attributes of AttributedString
    coreTextParams->lineBreakMode = kCTLineBreakByCharWrapping;
    
    CTParagraphStyleSetting settings[] = {
        { kCTParagraphStyleSpecifierLineBreakMode, sizeof(coreTextParams->lineBreakMode), &coreTextParams->lineBreakMode },
        { kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(coreTextParams->lineHeight), &coreTextParams->lineHeight },
        { kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(coreTextParams->lineHeight), &coreTextParams->lineHeight },
    };
    
    coreTextParams->settings = (CTParagraphStyleSetting*)&settings;
    
    coreTextParams->paragraphStyleRef = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
    coreTextParams->fontRef = CTFontCreateWithName((CFStringRef)[self.coreTextHelper italicFontNameByString:coreTextParams.fontName], coreTextParams->fontSize, NULL);
    NSAssert(coreTextParams->fontRef != NULL, @"ctFontRef 为 NULl");
    
    NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:(id)coreTextParams->fontRef, kCTFontAttributeName, (id)coreTextParams->paragraphStyleRef, kCTParagraphStyleAttributeName, nil];
    
    attStr = [[NSMutableAttributedString alloc] initWithString:self.text attributes:attributes];
    [attStr addAttribute:(id)kCTForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, self.text.length)];
    
    if (attributedStringRef) {//释放旧资源
        CFRelease(attributedStringRef);
        attributedStringRef = NULL;
    }
    
    attributedStringRef = (CFMutableAttributedStringRef)attStr;
    currentPage = 0;
}

- (void)loadVisibleTextForCFRange:(CFRange)rang InFrame:(CGRect)theRect
{
    OUT_FUNCTION_NAME();
    NSAutoreleasePool * pool = [NSAutoreleasePool new];
    CFArrayRef ctLinesArrayRef = NULL;
        
    if (framesetterRef == NULL) {
        framesetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedStringRef);
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat offset_x = 0.0f, offset_y = 0.0f;
    coreTextParams->visibleBounds = CGRectMake(offset_x, offset_y, theRect.size.width - offset_x * 2, theRect.size.height - offset_y * 2);
    CGPathAddRect(path, NULL, coreTextParams->visibleBounds);
    
    if (visibleFrameRef != NULL) {
        CFRelease(visibleFrameRef);
        visibleFrameRef = NULL;
    }
    visibleFrameRef = CTFramesetterCreateFrame(framesetterRef, rang, path, NULL);
    
    visibleRange = CTFrameGetVisibleStringRange(visibleFrameRef);
    
    if (ctLinesArrayRef != NULL) {
        CFRelease(ctLinesArrayRef);
        ctLinesArrayRef = NULL;
    }
    //获取可见区域文本行
    if (ctLinesArrayRef == NULL && visibleFrameRef != NULL) {
        ctLinesArrayRef = CFRetain(CTFrameGetLines(visibleFrameRef));
    }
    //计算当前页起始偏移和当前页字数
    startGlyphIndex += totalGlyphCount;
    totalGlyphCount = visibleRange.length;
    
    if (visibleLines != NULL) {
        CFRelease(visibleLines);
    }
    visibleLines = ctLinesArrayRef;
    
    //release CF object
    CFRelease(path);
    [pool drain];
}

- (void)loadAllPagesInFrame:(CGRect)theRect
{
    OUT_FUNCTION_NAME();
    
    currentPage = 0;
    startGlyphIndex = 0;
    totalGlyphCount = 0;
    CFRange range = CFRangeMake(0, 0);
    NSRange nsRange = NSMakeRange(0, 0);
    self.pagesInfo = [NSMutableArray array];
    if (framesetterRef != NULL) {
        CFRelease(framesetterRef);
        framesetterRef = NULL;
    }

    NSValue * rangeValue = nil;
    [self loadVisibleTextForCFRange:range InFrame:theRect];
    if (framesetterRef != NULL) {
        nsRange.length = totalGlyphCount;
        rangeValue = [NSValue valueWithRange:nsRange];
    }
    NSDate * date = [NSDate date];
    while (framesetterRef != NULL && text.length > startGlyphIndex + totalGlyphCount) {
        [pagesInfo addObject:rangeValue];
        range = CFRangeMake(startGlyphIndex, 0);
        [self loadVisibleTextForCFRange:range InFrame:theRect];
        if (framesetterRef == NULL) {
            break;
        }
        nsRange = NSMakeRange(startGlyphIndex, totalGlyphCount);
        rangeValue = [NSValue valueWithRange:nsRange];
    }
    NSDate * endDate = [NSDate date];
    NSLog(@"总共耗时 %f 毫秒； 共 %u 页", ([endDate timeIntervalSince1970] - [date timeIntervalSince1970]), [pagesInfo count]);
    [self loadCurrentPageInFrame:theRect];
}

- (void)loadPage:(NSUInteger)page InFrame:(CGRect)theRect
{
    if (page >= NSNotFound) {
        return;
    }
    if (page >= [pagesInfo count]) {
        return;
    }
    
    self.currentPage = page;
    NSLog(@"goto page :%u", page);
    NSRange range = [[pagesInfo objectAtIndex:currentPage] rangeValue];
    NSLog(@"ragne :%@", NSStringFromRange(range));
    [self loadVisibleTextForCFRange:CFRangeMake(range.location, range.length) InFrame:theRect];
}

- (void)loadCurrentPageInFrame:(CGRect)theRect
{
    [self loadPage:currentPage InFrame:theRect];
}

@end
