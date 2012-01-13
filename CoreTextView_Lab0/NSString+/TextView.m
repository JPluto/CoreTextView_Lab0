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

- (id)initWithFrame:(CGRect)frame
{
    OUT_FUNCTION_NAME();
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (txtProcessor == nil) {
            txtProcessor = [SimpleTextProcessor new];
            self.fontSize = txtProcessor->fontSize;
        }
    }
    return self;
}

- (id)init
{
    //OUT_FUNCTION_NAME();
    self = [super init];
    if (self) {
        if (txtProcessor == nil) {
            txtProcessor = [SimpleTextProcessor new];
            self.fontSize = txtProcessor->fontSize;
        }
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    //OUT_FUNCTION_NAME();
    self = [super initWithCoder:aDecoder];
    if (self) {
        if (txtProcessor == nil) {
            txtProcessor = [SimpleTextProcessor new];
            self.fontSize = txtProcessor->fontSize;
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
    //CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
    
    CGRect textFrame = CGRectZero;
    textFrame.origin.x = 10;
    textFrame.origin.y = 10;
    textFrame.size.width = self.frame.size.width - textFrame.origin.x * 2.0f;
    textFrame.size.height = self.frame.size.height - textFrame.origin.y * 2.0f;
    
    NSDate * date = [NSDate date];
    NSArray * strings = [txtProcessor textLinesFromRange:NSMakeRange(0, txtProcessor.text.length) OfString:txtProcessor.text inRect:textFrame UsingFont:txtProcessor.uiFont LineBreakMode:UILineBreakModeClip IsForward:NO];
    
    CGContextSetFillColorWithColor(context, [UIColor orangeColor].CGColor);
    CGContextFillRect(context, textFrame);
    
    //++++++++
    CGContextSetFillColorWithColor(context, txtProcessor.params.foregroundColor.CGColor);
    
    NSInteger avaibleLines = textFrame.size.height / txtProcessor.uiFont.lineHeight;
    
    CGRect lineRect = CGRectZero;
    for (int i = 0, _counter = 0; i < [strings count]; i++) {
        _counter ++;
        if (_counter > avaibleLines) {
            break;
        }
        lineRect.size = textFrame.size;
        lineRect.origin.x = 10;
        lineRect.origin.y = 10 + i * (txtProcessor.uiFont.lineHeight);
        
        //填充行背景色
        CGContextSetFillColorWithColor(context, [UIColor purpleColor].CGColor);
        NSString * _drawedStr = [strings objectAtIndex:i];
        CGSize _lineSize = [_drawedStr sizeWithFont:txtProcessor.uiFont];
        NSLog(@"%d %@  %@", i, NSStringFromCGSize(_lineSize), _drawedStr);
        //CGContextFillRect(context, CGRectMake(lineRect.origin.x, lineRect.origin.y, _lineSize.width, _lineSize.height));
        //画文字
        CGContextSetFillColorWithColor(context, txtProcessor.params.foregroundColor.CGColor);
        lineRect.size = _lineSize;
        [_drawedStr drawInRect:lineRect withFont:txtProcessor.uiFont];
    }
    
    //----------
    textFrame.origin.y = 0;
    textFrame.origin.x = 100;
    [[NSString stringWithFormat:@"总行数:%u 耗时:%f", [strings count], (double)(([[NSDate date] timeIntervalSince1970] - [date timeIntervalSince1970]))] drawInRect:textFrame withFont:[UIFont systemFontOfSize:12]];
    
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
    txtProcessor->fontSize = self.fontSize;
    [txtProcessor updateParams];
}

@end
