//
//  TextView.m
//  CoreTextView_Lab0
//
//  Created by Deheng Xu on 11-12-14.
//  Copyright 2011年 北京易天新动网络科技有限公司. All rights reserved.
//

#import "TextView.h"
#import "SimpleTextProcessor.h"

@implementation TextView

@synthesize font;
@synthesize txtProcessor;

- (id)initWithFrame:(CGRect)frame
{
    OUT_FUNCTION_NAME();
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.fontSize = 12;
        //self.font = [UIFont systemFontOfSize:fontSize];
        txtProcessor = [SimpleTextProcessor new];        
    }
    return self;
}

- (id)init
{
    OUT_FUNCTION_NAME();
    self = [super init];
    if (self) {
        self.fontSize = 12;
        txtProcessor = [SimpleTextProcessor new];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    OUT_FUNCTION_NAME();
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.fontSize = 12;
    }
    return self;
}

- (void)loadText:(NSString *)aString
{
    OUT_FUNCTION_NAME();
    [txtProcessor loadText:aString];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    OUT_FUNCTION_NAME();
    [super drawRect:rect];
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
    
    self.font = [UIFont systemFontOfSize:fontSize];
    
    CGRect textFrame = CGRectZero;
    textFrame.origin.x = 10;
    textFrame.origin.y = 10;
    textFrame.size.width = self.frame.size.width - 20;
    textFrame.size.height = self.frame.size.height - 20;
    
    NSDate * date = [NSDate date];
    NSArray * strings = [txtProcessor textLinesFromRange:NSMakeRange(0, txtProcessor.text.length) OfString:txtProcessor.text inRect:textFrame UsingFont:self.font LineBreakMode:UILineBreakModeCharacterWrap IsForward:NO];
    
    //++++++++
    CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
    
    NSInteger avaibleLines = textFrame.size.height / font.lineHeight;
    
    CGRect lineRect = CGRectZero;
    for (int i = 0, _counter = 0; i < [strings count]; i++) {
        _counter ++;
        if (_counter > avaibleLines) {
            break;
        }
        lineRect.size = textFrame.size;
        lineRect.origin.x = 10;
        lineRect.origin.y = 10 + i * (font.lineHeight + 0);
        [[strings objectAtIndex:i] drawInRect:lineRect withFont:self.font];
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

@end
