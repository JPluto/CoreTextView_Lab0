//
//  SimpleTextParams.h
//  CoreTextView_Lab0
//
//  Created by Xu Deheng on 12-1-10.
//  Copyright (c) 2012年 北京易天新动网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimpleTextParams : NSObject
{
@public
    //前景色
    UIColor * foregroundColor;
    //背景色
    UIColor * backgroundColor;
    //行间距
    CGFloat lineSpace;
    //行高
    CGFloat lineHeight;
    //字间距
    CGFloat charSpace;
    //可视区域
    CGRect visibleBounds;
    //字号
    CGFloat fontSize;
    //UIFont 字体
    UIFont * uiFont;
    //字体名
    NSString * fontName;
}

@property (nonatomic, retain) UIColor * foregroundColor;
@property (nonatomic, retain) UIColor * backgroundColor;
@property (nonatomic) CGFloat lineSpace;
@property (nonatomic) CGFloat lineHeight;
@property (nonatomic) CGFloat charSpace;
@property (nonatomic) CGRect visibleBounds;
@property (nonatomic) CGFloat fontSize;
@property (nonatomic, retain) UIFont * uiFont;
@property (nonatomic, retain) NSString * fontName;

- (void)update;
- (UIFont*)fontWithSize:(CGFloat)size;
- (UIFont*)font;

@end
