//
//  SimpleTextProcessor.m
//  CoreTextView_Lab0
//
//  Created by Deheng Xu on 11-12-15.
//  Copyright 2011年 北京易天新动网络科技有限公司. All rights reserved.
//

#import "SimpleTextProcessor.h"

@implementation SimpleTextProcessor

@synthesize uiFont;
@synthesize pagesInfo;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
        if (uiFont == nil) {
            uiFont = [UIFont systemFontOfSize:fontSize];
        }
        if (pagesInfo == nil) {
            pagesInfo = [NSMutableArray new];
        }
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)initSimpleTextParams
{
    fontSize = 15.0f;
    lineSpace = 0.0f;
}

- (NSArray *)textLinesFromString:(NSString *)theString inRect:(CGRect)theRect usingFont:(UIFont *)theFont lineBreakMode:(UILineBreakMode)breakMode
{
    NSMutableArray * tmp = [[NSMutableArray new] autorelease];
    NSMutableString * mutableString = nil;
    CGSize tmpSize;
    
    NSDate * startDate = [NSDate date];
    int  i, count = [theString length];
    NSAutoreleasePool * __pool = [NSAutoreleasePool new];
    for (i = 0; i < count; i++) {
        if (mutableString == nil) {
            mutableString = [NSMutableString string];
        }
        
        [mutableString appendFormat:@"%@", [theString substringWithRange:NSMakeRange(i, 1)]];
        
        //tmpSize = [mutableString sizeWithFont:theFont forWidth:theRect.size.width lineBreakMode:breakMode];
        tmpSize = [mutableString sizeWithFont:theFont constrainedToSize:theRect.size lineBreakMode:breakMode];
        
//        NSLog(@"tmpSize :%@; theRect:%@", NSStringFromCGSize(tmpSize), NSStringFromCGRect(theRect));
//        NSLog(@"lineHeight :%f", theFont.lineHeight);
        if (tmpSize.height > theFont.lineHeight) {//遍历回溯，出现折返行
            [tmp addObject:[mutableString substringToIndex:mutableString.length - 1]];
            mutableString = [NSMutableString new];
            
            if ([tmp count] * theFont.lineHeight > theRect.size.height) {
                [tmp removeLastObject];
                break;
            }
            if (i >= count - 1) {
                break;
            }else {
                [mutableString appendFormat:[theString substringWithRange:NSMakeRange(i, 1)]];
            }
        }else {
            if (i >= count - 1) {
                [tmp addObject:mutableString];
                mutableString = nil;
                break;
            }
        }
    }
    [__pool drain];

    NSDate * endDate = [NSDate date];
    NSLog(@"result :%u  耗时 :%f", tmp.count, ([endDate timeIntervalSince1970] - [startDate timeIntervalSince1970]));
    return [NSArray arrayWithArray:tmp];
}

@end
