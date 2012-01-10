//
//  SimpleTextProcessor.h
//  CoreTextView_Lab0
//
//  Created by Deheng Xu on 11-12-15.
//  Copyright 2011年 北京易天新动网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimpleTextProcessor : NSObject
{
@public
    CGFloat lineSpace;
    CGFloat lineHeight;
    CGFloat fontSize;
    UIFont * uiFont;
}

@property (nonatomic, retain) UIFont * uiFont;

- (NSArray *) textLinesFromString:(NSString*)theString inRect:(CGRect)theRect usingFont:(UIFont*)theFont lineBreakMode:(UILineBreakMode) breakMode;

@end
