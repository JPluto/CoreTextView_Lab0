//
//  TextView.m
//  CoreTextView_Lab0
//
//  Created by Deheng Xu on 11-12-14.
//  Copyright 2011年 北京易天新动网络科技有限公司. All rights reserved.
//

#import "TextView.h"
#import "SimpleTextProcessor.h"
#import "SimpleTextParams.h"

@implementation TextView

@synthesize processor;

static SimpleTextParams * _globalTextParams;
+ (SimpleTextParams *)uniqTextParams
{
    if (_globalTextParams == nil) {
        _globalTextParams = [SimpleTextParams new];
    }
    return _globalTextParams;
}

- (id)initWithFrame:(CGRect)frame
{
    OUT_FUNCTION_NAME();
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (processor == nil) {
            self.processor = [SimpleTextProcessor processorWithParams:[TextView uniqTextParams]];
            self.processor.params.foregroundColor = [UIColor blackColor];
            self.processor.params.backgroundColor = [UIColor clearColor];
        }
    }
    return self;
}

- (id)init
{
    OUT_FUNCTION_NAME();
    self = [super init];
    if (self) {
        if (processor == nil) {
            self.processor = [SimpleTextProcessor processorWithParams:[TextView uniqTextParams]];
            self.processor.params.foregroundColor = [UIColor blackColor];
            self.processor.params.backgroundColor = [UIColor clearColor];
        }
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    OUT_FUNCTION_NAME();
    self = [super initWithCoder:aDecoder];
    if (self) {
        if (processor == nil) {
            self.processor = [SimpleTextProcessor processorWithParams:[TextView uniqTextParams]];
            self.processor.params.foregroundColor = [UIColor blackColor];
            self.processor.params.backgroundColor = [UIColor clearColor];
        }
    }
    return self;
}

- (void)loadText:(NSString *)aString
{
    OUT_FUNCTION_NAME();
    [processor loadText:aString];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //OUT_FUNCTION_NAME();
    [super drawRect:rect];
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect textFrame = CGRectZero;
    textFrame.origin.x = 10;
    textFrame.origin.y = 10;
    textFrame.size.width = self.frame.size.width - textFrame.origin.x * 2.0f;
    textFrame.size.height = self.frame.size.height - textFrame.origin.y * 2.0f;
//    processor.params.visibleBounds = textFrame;
    
    NSDate * date = [NSDate date];
    //加载文本
    //[processor textLinesFromRange:NSMakeRange(0, processor.text.length) OfString:processor.text inRect:textFrame UsingFont:processor.params.uiFont LineBreakMode:UILineBreakModeClip IsForward:YES];
    
    //填充测试背景色
    CGContextSetFillColorWithColor(context, processor.params.backgroundColor.CGColor);
    CGContextFillRect(context, self.bounds);
    
    CGContextSetFillColorWithColor(context, processor.params.foregroundColor.CGColor);    
    
    /*
    NSInteger avaibleLines = processor.params.visibleBounds.size.height / processor.params.uiFont.lineHeight;
    NSLog(@"avaibleLines :%u; strings :%u", avaibleLines, [processor.visibleLines count]);
    NSLog(@"start :%u, total :%u", processor->startGlyphIndex, processor->totalGlyphCount);
    NSLog(@"[%@]", [processor.text substringWithRange:NSMakeRange(processor->startGlyphIndex, processor->totalGlyphCount)]);
    */
    
    CGRect lineRect = CGRectZero;
    for (int i = 0, _counter = 0; i < [processor.visibleLines count]; i++) {
        _counter ++;

        lineRect.size = processor.params.visibleBounds.size;
        lineRect.origin.x = 10;
        lineRect.origin.y = 10 + i * (processor.params.uiFont.lineHeight);
        
        NSString * _drawedStr = [processor.visibleLines objectAtIndex:i];
        /*
        //填充行背景色
        CGContextSetFillColorWithColor(context, [UIColor purpleColor].CGColor);
        CGSize _lineSize = [_drawedStr sizeWithFont:processor.uiFont];
        NSLog(@"%d %@  %@", i, NSStringFromCGSize(_lineSize), _drawedStr);
        CGContextFillRect(context, CGRectMake(lineRect.origin.x, lineRect.origin.y, _lineSize.width, _lineSize.height));
        */
        //画文字
        CGContextSetFillColorWithColor(context, processor.params.foregroundColor.CGColor);
        lineRect.size.width = self.bounds.size.width * 2;
        [_drawedStr drawInRect:lineRect withFont:processor.params.uiFont];
    }
    
#if DEBUG_SHOW_TIME_ONVIEW
    textFrame.origin.y = -5;
    [[NSString stringWithFormat:@"总行数:%u 耗时:%f", [processor.visibleLines count], (double)(([[NSDate date] timeIntervalSince1970] - [date timeIntervalSince1970]))] drawInRect:textFrame withFont:[UIFont systemFontOfSize:12]];
#endif
}

//- (void)refreshText:(NSString *)aString
//{
//    NSAutoreleasePool * pool = [NSAutoreleasePool new];
//    @synchronized(processor) {
//        [self loadText:aString];
//        [processor loadAllPagesInFrame:self.frame];
//        [self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
//    }
//    [pool drain];
//
//}

- (void)updateTextParams
{
    //processor.params->fontSize = self.fontSize;
    [processor updateParams];
}

@end
