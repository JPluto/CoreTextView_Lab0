//
//  CoreTextView.m
//  CoreTextView_Lab0
//
//  Created by Deheng Xu on 11-11-11.
//  Copyright 2011年 北京易天新动网络科技有限公司. All rights reserved.
//

#import "CoreTextView.h"

@implementation CoreTextView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"%@", [[NSString alloc] initWithCString:__FUNCTION__ encoding:NSUTF8StringEncoding]);
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"%@", [[NSString alloc] initWithCString:__FUNCTION__ encoding:NSUTF8StringEncoding]);
        selectedRect = CGRectZero;
        self.lineSpace = 30.0f;
        self.lineHeight = 18;
        self.fontSize = 18.0;
        NSLog(@"fontSize :%f, lineSpace :%f", fontSize, lineSpace);
        selectedStartIndex = -1;
        selectedEndIndex = -1;
    }
    return self;
}

- (void)dealloc
{
    if (ctLinesArrayRef != NULL) {
        CFRelease(ctLinesArrayRef);
    }
    if (cfAttrStringRef != NULL) {
        CFRelease(cfAttrStringRef);
    }
    [super dealloc];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    OUT_FUNCTION_NAME();
    [super drawRect:rect];
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context != m_Context) {
        m_Context = context;
    }
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
    
    /*
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:(200. / 255.0) green:0 / 255.0 blue:0 / 255.0 alpha:0.7] CGColor]);
    CGContextFillRect(context, selectedRect);
     */
	
    if (ctLinesArrayRef != NULL) {
#if DRAW_TEXT_LINE_BY_LINE
        //draw text frame setter
        CTFrameDraw(visibleFrameRef, context);
#else
        //draw text line by line
        CFIndex lineIdx = 0;
        CGFloat ascent, descent, leading;
        double bounds;
        CGRect ctlineBounds;
        CGRect ctLineSelectBounds;
        int j;
        CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
		//for (lineIdx = 0, j = 0; lineIdx < CFArrayGetCount(ctLinesArrayRef); lineIdx++, j++) {
        for (lineIdx = CFArrayGetCount(ctLinesArrayRef) - 1, j = 0; lineIdx >= 0; lineIdx--, j++) {
            ctLineSelectBounds = CGRectZero;
            bounds = CTLineGetTypographicBounds(CFArrayGetValueAtIndex(ctLinesArrayRef, lineIdx), &ascent, &descent, &leading);
            //NSLog(@"bounds :%f, ascent :%f, descent :%f, leading :%f, lineSpace :%f", bounds, ascent, descent, leading, lineSpace);
            ctlineBounds = CTLineGetImageBounds(CFArrayGetValueAtIndex(ctLinesArrayRef, lineIdx), context);
            //NSLog(@"%@", NSStringFromCGRect(ctlineBounds));
            NSLog(@"fontSize :%f, lineSpace :%f", fontSize, lineSpace);
            CGContextSetTextPosition(context, visibleBounds.origin.x, visibleBounds.origin.y + (j + 1) * (ascent  + lineSpace));
            CTLineDraw(CFArrayGetValueAtIndex(ctLinesArrayRef, lineIdx), context);
        }
#endif   
    }
}

- (void)loadText:(NSString *)aString
{
    NSLog(@"%@", DEBUG_FUNCTION_NAME);
    self.text = [aString stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
    
    NSMutableAttributedString * attStr = nil;
	//Helvetica
    UIFont * font = [UIFont fontWithName:@"Arial" size:fontSize];
    
    //config attributes of AttributedString
    CTParagraphStyleSetting settings[] = {
        { kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(lineHeight), &lineHeight },
        { kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(lineHeight), &lineHeight },
    };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
    NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, (NSString *)kCTFontAttributeName, paragraphStyle, kCTParagraphStyleAttributeName, nil];
    attStr = [[[NSMutableAttributedString alloc] initWithString:self.text attributes:attributes] autorelease];
    
    [attStr addAttribute:(id)kCTForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, 100)];
    
    CFMutableAttributedStringRef attrString = (CFMutableAttributedStringRef) attStr;
    
    if (cfAttrStringRef) {
        CFRelease(cfAttrStringRef);
        cfAttrStringRef = NULL;
    }
    self->cfAttrStringRef = (CFMutableAttributedStringRef)CFRetain(attrString);
    
    //[self loadVisibleTextForCFRange:CFRangeMake(startGlyphIndex + totalGlyphCount, 0)];
	[self loadVisibleTextForCFRange:CFRangeMake(0, 0)];
}

- (void)loadVisibleTextForCFRange:(CFRange)rang
{
    OUT_FUNCTION_NAME();
    NSAutoreleasePool * pool = [NSAutoreleasePool new];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(self->cfAttrStringRef);
    CGMutablePathRef path = CGPathCreateMutable();
    visibleBounds = CGRectMake(10.0, 10.0, self.frame.size.width - 20, self.frame.size.height - 20);
    CGPathAddRect(path, NULL, visibleBounds);
    
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
    
    if (ctLinesArrayRef == NULL && visibleFrameRef != NULL) {
        ctLinesArrayRef = CFRetain(CTFrameGetLines(visibleFrameRef));
    }
    
    CFIndex _total = 0;
    if (ctLinesArrayRef != NULL) {
        for (int i = 0; i < CFArrayGetCount(ctLinesArrayRef); i++) {
            CTLineRef ctLine = CFArrayGetValueAtIndex(ctLinesArrayRef, i);
            _total += CTLineGetGlyphCount(ctLine);
        }
    }
    startGlyphIndex += totalGlyphCount;
    totalGlyphCount = _total;
    
    //release CF object
    CFRelease(framesetter);
    CFRelease(path);
    [pool drain];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * tap = [touches anyObject];
    selectedRect = CGRectZero;
    selectedRect.origin = [tap locationInView:self];
    selectedStartLine = -1;
    selectedEndLine = -1;
    
    if (ctLinesArrayRef != NULL) {
        for (int i = 0; i < CFArrayGetCount(ctLinesArrayRef); i++) {
            CTLineRef ctLine = CFArrayGetValueAtIndex(ctLinesArrayRef, i);
            selectedStartIndex = CTLineGetStringIndexForPosition(ctLine, [tap locationInView:self]);
            CGFloat secondaryOff;
            CGFloat offset = CTLineGetOffsetForStringIndex(ctLine, selectedStartIndex, &secondaryOff);
            NSLog(@"cfindex :%lu;  offset :%f,  2ndOff :%f", selectedStartIndex, offset, secondaryOff);
            if (selectedRect.origin.y < visibleBounds.origin.y + fontSize * (i + 1) && selectedRect.origin.y > visibleBounds.origin.y + fontSize * i) {
                selectedStartLine = i;
                selectedEndLine = i;
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * tap = [touches anyObject];
    
    CGFloat secondaryOff;
    CGFloat offset;
    if (ctLinesArrayRef != NULL) {
        for (int i = 0; i < CFArrayGetCount(ctLinesArrayRef); i++) {
            CTLineRef ctLine = CFArrayGetValueAtIndex(ctLinesArrayRef, i);
            selectedEndIndex = CTLineGetStringIndexForPosition(ctLine, [tap locationInView:self]);
            offset = CTLineGetOffsetForStringIndex(ctLine, selectedEndIndex, &secondaryOff);
            if (selectedRect.origin.y < fontSize * (i + 1) && selectedRect.origin.y > fontSize * i) {
                selectedEndIndex = i;
            }
        }
    }

    selectedRect.size.width = ([tap locationInView:self].x - selectedRect.origin.x);
    selectedRect.size.height = ([tap locationInView:self].y - selectedRect.origin.y);
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"%@", [[NSString alloc] initWithCString:__FUNCTION__ encoding:NSUTF8StringEncoding]);
    UITouch * tap = [touches anyObject];
    
    CGPoint tapPoint = [tap locationInView:self];
    tapPoint.x -= 10;
    //selected charactor
    for (int i = 0; i < CFArrayGetCount(ctLinesArrayRef); i++) {
        CTLineRef ctLine = CFArrayGetValueAtIndex(ctLinesArrayRef, i);
        CFIndex cfIndex = CTLineGetStringIndexForPosition(ctLine, tapPoint);
        CGFloat secondaryOff;
        CGFloat offset = CTLineGetOffsetForStringIndex(ctLine, cfIndex, &secondaryOff);
        NSLog(@"%@  cfindex :%lu;  offset :%f,  2ndOff :%f", [(NSString *)CFAttributedStringGetString(self->cfAttrStringRef) substringWithRange:NSMakeRange(cfIndex, 1)], cfIndex, offset, secondaryOff);
    }
    
    //selectedRect.size = CGSizeZero;
    
    //NSLog(@"x :%f;  y :%f", [tap locationInView:self].x, [tap locationInView:self].y);
    /*
    //if ([tap locationInView:self].x < 10 || [tap locationInView:self].x > self.frame.size.width - 20) {
        CGPoint tapPoint = [tap locationInView:self];
        CGFloat left = self.frame.size.width / 4;
        if (tapPoint.x <= left) {
            //NSLog(@"Turn previous");
            NSMutableAttributedString * attribStr = (NSMutableAttributedString *) cfAttrStringRef;
            CFIndex _index = self->startGlyphIndex - self->totalGlyphCount;
            
            if (_index < 0) {
                _index = 0;
            }
            if (_index >= 0) {
                CFRelease(ctLinesArrayRef);
                ctLinesArrayRef = NULL;
                [self loadVisibleTextForCFRange:CFRangeMake(_index, 0)];
            }
        }else if (tapPoint.x >= self.frame.size.width - left) {
            //NSLog(@"Turn next");
            CFRelease(ctLinesArrayRef);
            ctLinesArrayRef = NULL;
            [self loadVisibleTextForCFRange:CFRangeMake(self->startGlyphIndex + self->totalGlyphCount, 0)];
        }
    //}
    */
    [self setNeedsDisplay];
}

@end
