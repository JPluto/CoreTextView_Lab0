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

@synthesize txtProcessor;

static SimpleTextParams * _globalTextParams;
+ (SimpleTextParams *)uniqTextParams
{
    if (_globalTextParams == nil) {
        _globalTextParams = [SimpleTextParams new];
    }
    //NSAssert(_globalTextParams != nil, @"_globalTextParams 创建错误！");
    return _globalTextParams;
}

- (id)initWithFrame:(CGRect)frame
{
    OUT_FUNCTION_NAME();
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (txtProcessor == nil) {
            self.txtProcessor = [SimpleTextProcessor processorWithParams:[TextView uniqTextParams]];
            self.txtProcessor.params.foregroundColor = [UIColor blackColor];
            self.txtProcessor.params.backgroundColor = [UIColor clearColor];
            self.fontSize = txtProcessor.params.fontSize;
        }
    }
    return self;
}

- (id)init
{
    OUT_FUNCTION_NAME();
    self = [super init];
    if (self) {
        if (txtProcessor == nil) {
            self.txtProcessor = [SimpleTextProcessor processorWithParams:[TextView uniqTextParams]];
            self.txtProcessor.params.foregroundColor = [UIColor blackColor];
            self.txtProcessor.params.backgroundColor = [UIColor clearColor];
            self.fontSize = txtProcessor.params->fontSize;
        }
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    OUT_FUNCTION_NAME();
    self = [super initWithCoder:aDecoder];
    if (self) {
        if (txtProcessor == nil) {
            self.txtProcessor = [SimpleTextProcessor processorWithParams:[TextView uniqTextParams]];
            self.fontSize = txtProcessor.params->fontSize;
        }
    }
    return self;
}

- (void)loadText:(NSString *)aString
{
    //OUT_FUNCTION_NAME();
    [txtProcessor loadText:aString];
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
    txtProcessor.params.visibleBounds = textFrame;
    
    NSDate * date = [NSDate date];
    //加载文本
    [txtProcessor textLinesFromRange:NSMakeRange(0, txtProcessor.text.length) OfString:txtProcessor.text inRect:textFrame UsingFont:txtProcessor.params.uiFont LineBreakMode:UILineBreakModeClip IsForward:NO];
    
    //填充测试背景色
    CGContextSetFillColorWithColor(context, txtProcessor.params.backgroundColor.CGColor);
    CGContextFillRect(context, self.bounds);
    
    CGContextSetFillColorWithColor(context, txtProcessor.params.foregroundColor.CGColor);    
    
    /*
    NSInteger avaibleLines = txtProcessor.params.visibleBounds.size.height / txtProcessor.params.uiFont.lineHeight;
    NSLog(@"avaibleLines :%u; strings :%u", avaibleLines, [txtProcessor.visibleLines count]);
    NSLog(@"start :%u, total :%u", txtProcessor->startGlyphIndex, txtProcessor->totalGlyphCount);
    NSLog(@"[%@]", [txtProcessor.text substringWithRange:NSMakeRange(txtProcessor->startGlyphIndex, txtProcessor->totalGlyphCount)]);
    */
    
    CGRect lineRect = CGRectZero;
    for (int i = 0, _counter = 0; i < [txtProcessor.visibleLines count]; i++) {
        _counter ++;

        lineRect.size = txtProcessor.params.visibleBounds.size;
        lineRect.origin.x = 10;
        lineRect.origin.y = 10 + i * (txtProcessor.params.uiFont.lineHeight);
        
        NSString * _drawedStr = [txtProcessor.visibleLines objectAtIndex:i];
        /*
        //填充行背景色
        CGContextSetFillColorWithColor(context, [UIColor purpleColor].CGColor);
        CGSize _lineSize = [_drawedStr sizeWithFont:txtProcessor.uiFont];
        NSLog(@"%d %@  %@", i, NSStringFromCGSize(_lineSize), _drawedStr);
        CGContextFillRect(context, CGRectMake(lineRect.origin.x, lineRect.origin.y, _lineSize.width, _lineSize.height));
        */
        //画文字
        CGContextSetFillColorWithColor(context, txtProcessor.params.foregroundColor.CGColor);
        lineRect.size.width = self.bounds.size.width * 2;
        [_drawedStr drawInRect:lineRect withFont:txtProcessor.params.uiFont];
    }
    
#if DEBUG_SHOW_TIME_ONVIEW
    textFrame.origin.y = -5;
    [[NSString stringWithFormat:@"总行数:%u 耗时:%f", [txtProcessor.visibleLines count], (double)(([[NSDate date] timeIntervalSince1970] - [date timeIntervalSince1970]))] drawInRect:textFrame withFont:[UIFont systemFontOfSize:12]];
#endif
}

- (void)refreshText:(NSString *)aString
{
    NSAutoreleasePool * pool = [NSAutoreleasePool new];
    @synchronized(txtProcessor) {
        [self loadText:aString];
        [txtProcessor loadAllPagesInFrame:self.frame];
        [self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
    }
    [pool drain];

}

- (void)updateTextParams
{
    txtProcessor.params->fontSize = self.fontSize;
    [txtProcessor updateParams];
}

@end
