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

@synthesize text;
@synthesize font;
@synthesize fontSize;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        fontSize = 12;
        //self.font = [UIFont systemFontOfSize:fontSize];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        fontSize = 12;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        fontSize = 12;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    NSLog(@"%@", DEBUG_FUNCTION_NAME);
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
    
    self.font = [UIFont systemFontOfSize:fontSize];
    
    CGRect textFrame = CGRectZero;
    textFrame.origin.x = 10;
    textFrame.origin.y = 10;
    textFrame.size.width = self.frame.size.width - 20;
    textFrame.size.height = self.frame.size.height - 20;
    
    SimpleTextProcessor * processor = [SimpleTextProcessor new];
    NSArray * strings = [processor textLinesFromString:self.text inRect:textFrame usingFont:self.font lineBreakMode:UILineBreakModeCharacterWrap];
    
    NSInteger times = 50;
    NSDate * date = [NSDate date];
    //++++++++
//    CGContextSetFillColorWithColor(context, [[UIColor grayColor] CGColor]);
//    CGContextFillRect(context, textFrame);    
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    
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
    
    [processor release];
    //----------
    textFrame.origin.y = 0;
    textFrame.origin.x = 100;
    [[NSString stringWithFormat:@"%d次 耗时:%f", times, (double)(([[NSDate date] timeIntervalSince1970] - [date timeIntervalSince1970]))] drawInRect:textFrame withFont:[UIFont systemFontOfSize:12]];
    
}


@end
