//
//  SimpleTextProcessor.m
//  CoreTextView_Lab0
//
//  Created by Deheng Xu on 11-12-15.
//  Copyright 2011年 北京易天新动网络科技有限公司. All rights reserved.
//

#import "SimpleTextProcessor.h"

@implementation SimpleTextProcessor

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (NSArray *)textLinesFromString:(NSString *)theString inRect:(CGRect)theRect usingFont:(UIFont *)theFont lineBreakMode:(UILineBreakMode)breakMode
{
    NSDate * startDate = [NSDate date];
    NSMutableArray * tmp = [NSMutableArray new];
    NSMutableString * mutableString = nil;
    CGSize tmpSize;
    
    int  i, count = [theString length];
//    NSLog(@"string count :%u", [theString length]);
    NSAutoreleasePool * __pool = [NSAutoreleasePool new];
    for (i = 0; i < count; i++) {
        if (mutableString == nil) {
            mutableString = [NSMutableString string];
        }
        
        [mutableString appendFormat:@"%@", [theString substringWithRange:NSMakeRange(i, 1)]];
//        NSLog(@"->%@", mutableString);
        
        //tmpSize = [mutableString sizeWithFont:theFont forWidth:theRect.size.width lineBreakMode:breakMode];
        tmpSize = [mutableString sizeWithFont:theFont constrainedToSize:theRect.size lineBreakMode:breakMode];
        
//        NSLog(@"tmpSize :%@; theRect:%@", NSStringFromCGSize(tmpSize), NSStringFromCGRect(theRect));
//        NSLog(@"lineHeight :%f", theFont.lineHeight);
        if (tmpSize.height > theFont.lineHeight) {//遍历回溯
            
            [tmp addObject:[mutableString substringToIndex:mutableString.length - 1]];
            mutableString = [NSMutableString new];
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
