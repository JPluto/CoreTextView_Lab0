//
//  CoreTextView.m
//  CoreTextView_Lab0
//
//  Created by Deheng Xu on 11-11-11.
//  Copyright 2011年 北京易天新动网络科技有限公司. All rights reserved.
//

#import "CoreTextView.h"

@implementation CoreTextView

@synthesize fontSize;

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
        lineSpace = 8.0;
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
    [super drawRect:rect];
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context != m_Context) {
        m_Context = context;
    }
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1, -1));
    
    
    CFIndex lineIdx = 0;
    CGFloat ascent, descent, leading;
    double bounds;
    CGRect ctlineBounds;
    CGRect ctLineSelectBounds;
        
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:(200. / 255.0) green:200. / 255.0 blue:0 / 255.0 alpha:0.7] CGColor]);
    CGContextFillRect(context, selectedRect);
        
    CGMutablePathRef fillPaths = CGPathCreateMutable();

    if (ctLinesArrayRef != NULL) {
        for (lineIdx = 0; lineIdx < CFArrayGetCount(ctLinesArrayRef); lineIdx++) {
            ctLineSelectBounds = CGRectZero;
            bounds = CTLineGetTypographicBounds(CFArrayGetValueAtIndex(ctLinesArrayRef, lineIdx), &ascent, &descent, &leading);
            //NSLog(@"bounds :%f, ascent :%f, descent :%f, leading :%f", bounds, ascent, descent, leading);
            ctlineBounds = CTLineGetImageBounds(CFArrayGetValueAtIndex(ctLinesArrayRef, lineIdx), context);
            NSLog(@"%@", NSStringFromCGRect(ctlineBounds));
            fontHeight = ascent + lineSpace;
//            if (selectedEndIndex == -1 && selectedStartIndex == -1) {
//            }else {
                NSLog(@"selectedStartIndex :%ld;  selectedEndIndex :%ld", selectedStartIndex, selectedEndIndex);
//                if (lineIdx == selectedStartIndex) {
//                    ctLineSelectBounds.origin.x = visibleBounds.origin.x;
//                    ctLineSelectBounds.origin.y = visibleBounds.origin.y + (lineIdx + 1) * fontHeight;
//                    ctLineSelectBounds.size.width = bounds;
//                    ctLineSelectBounds.size.height = fontHeight;
//                }else if (lineIdx == selectedEndIndex) {
//                    ctLineSelectBounds.origin.x = visibleBounds.origin.x;
//                    ctLineSelectBounds.origin.y = visibleBounds.origin.y + (lineIdx + 1) * fontHeight;
//                    ctLineSelectBounds.size.width = bounds;
//                    ctLineSelectBounds.size.height = fontHeight;
//                }else {
                if (lineIdx >= selectedStartIndex && lineIdx <= selectedEndLine) {
                    ctLineSelectBounds.origin.x = visibleBounds.origin.x;
                    ctLineSelectBounds.origin.y = visibleBounds.origin.y + (lineIdx) * fontHeight;
                    ctLineSelectBounds.size.width = bounds;
                    ctLineSelectBounds.size.height = fontHeight;
                    CGContextSetFillColorWithColor(context, [UIColor purpleColor].CGColor);
                    CGContextFillRect(context, ctLineSelectBounds);
                }
//            }
            CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
            CGContextSetTextPosition(context, visibleBounds.origin.x, visibleBounds.origin.y + (lineIdx + 1) * fontHeight);
            CTLineDraw(CFArrayGetValueAtIndex(ctLinesArrayRef, lineIdx), context);
        }
    }
    
    CFRelease(fillPaths);
}

- (void)loadVisibleTextForCFRange:(CFRange)rang
{
    NSAutoreleasePool * pool = [NSAutoreleasePool new];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(self->cfAttrStringRef);
    CGMutablePathRef path = CGPathCreateMutable();
    visibleBounds = CGRectMake(10.0, 10.0, self.frame.size.width - 20, self.frame.size.height - 20);
    CGAffineTransform cgTransform = CGAffineTransformMakeScale(1, -1);
    CGPathAddRect(path, &cgTransform, visibleBounds);
    
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
            if (selectedRect.origin.y < visibleBounds.origin.y + fontHeight * (i + 1) && selectedRect.origin.y > visibleBounds.origin.y + fontHeight * i) {
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
            if (selectedRect.origin.y < fontHeight * (i + 1) && selectedRect.origin.y > fontHeight * i) {
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
//    for (int i = 0; i < CFArrayGetCount(ctLinesArrayRef); i++) {
//        CTLineRef ctLine = CFArrayGetValueAtIndex(ctLinesArrayRef, i);
//        CFIndex cfIndex = CTLineGetStringIndexForPosition(ctLine, [tap locationInView:self]);
//        CGFloat secondaryOff;
//        CGFloat offset = CTLineGetOffsetForStringIndex(ctLine, cfIndex, &secondaryOff);
//        NSLog(@"%@  cfindex :%lu;  offset :%f,  2ndOff :%f", [(NSString *)CFAttributedStringGetString(self->cfAttrStringRef) substringWithRange:NSMakeRange(cfIndex, 1)], cfIndex, offset, secondaryOff);
//    }
    
    //selectedRect.size = CGSizeZero;
    
    //NSLog(@"x :%f;  y :%f", [tap locationInView:self].x, [tap locationInView:self].y);
    //if ([tap locationInView:self].x < 10 || [tap locationInView:self].x > self.frame.size.width - 20) {
        CGPoint tapPoint = [tap locationInView:self];
        CGFloat left = self.frame.size.width / 4;
        if (tapPoint.x <= left) {
            //NSLog(@"Turn previous");
            NSMutableAttributedString * attribStr = (NSMutableAttributedString *) cfAttrStringRef;
            [attribStr addAttribute:(NSString*)kCTForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, attribStr.length)];
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
    
    [self setNeedsDisplay];
}

@end
