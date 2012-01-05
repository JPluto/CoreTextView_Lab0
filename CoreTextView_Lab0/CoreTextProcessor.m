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
    }
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
    NSLog(@"%@ %@", DEBUG_FUNCTION_NAME, NSStringFromCGRect(coreTextView.frame));
    if (aString.length > 0) {
        self.text = [aString stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
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
    
    coreTextParams->settings = &settings;
    
    coreTextParams->paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
    coreTextParams->fontRef = CTFontCreateWithName((CFStringRef)[self.coreTextHelper italicFontNameByString:coreTextParams.fontName], coreTextParams->fontSize, NULL);
    NSAssert(coreTextParams->fontRef != NULL, @"ctFontRef 为 NULl");
    
    NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:(id)coreTextParams->fontRef, kCTFontAttributeName, (id)coreTextParams->paragraphStyle, kCTParagraphStyleAttributeName, nil];
    
    attStr = [[NSMutableAttributedString alloc] initWithString:self.text attributes:attributes];
    [attStr addAttribute:(id)kCTForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, self.text.length)];
    
    if (attributedStringRef) {//释放旧资源
        CFRelease(attributedStringRef);
        attributedStringRef = NULL;
    }
    
    attributedStringRef = (CFMutableAttributedStringRef)attStr;
}

- (void)loadVisibleTextForCFRange:(CFRange)rang
{
    OUT_FUNCTION_NAME();
    NSAutoreleasePool * pool = [NSAutoreleasePool new];
    CFArrayRef ctLinesArrayRef = NULL;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedStringRef);
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat offset_x = 0.0f, offset_y = 0.0f;
    coreTextParams->visibleBounds = CGRectMake(offset_x, offset_y, coreTextView.frame.size.width - offset_x * 2, coreTextView.frame.size.height - offset_y * 2);
    CGPathAddRect(path, NULL, coreTextParams->visibleBounds);
    
    if (visibleFrameRef != NULL) {
        CFRelease(visibleFrameRef);
        visibleFrameRef = NULL;
    }
    visibleFrameRef = CTFramesetterCreateFrame(framesetter, rang, path, NULL);
    
    visibleRange = CTFrameGetVisibleStringRange(visibleFrameRef);
    
    if (ctLinesArrayRef != NULL) {
        CFRelease(ctLinesArrayRef);
        ctLinesArrayRef = NULL;
    }
    //获取可见区域文本行
    if (ctLinesArrayRef == NULL && visibleFrameRef != NULL) {
        ctLinesArrayRef = CFRetain(CTFrameGetLines(visibleFrameRef));
    }
    //计算当前页字数
    CFIndex _total = 0;
    if (ctLinesArrayRef != NULL) {
        for (int i = 0; i < CFArrayGetCount(ctLinesArrayRef); i++) {
            CTLineRef ctLine = CFArrayGetValueAtIndex(ctLinesArrayRef, i);
            _total += CTLineGetGlyphCount(ctLine);
        }
    }
    startGlyphIndex += totalGlyphCount;
    totalGlyphCount = _total;
    
    visibleLines = ctLinesArrayRef;
    
    //release CF object
    CFRelease(framesetter);
    CFRelease(path);
    [pool drain];
}


@end
