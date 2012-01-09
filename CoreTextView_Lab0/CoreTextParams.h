//
//  CoreTextParams.h
//  CoreTextView_Lab0
//
//  Created by Xu Deheng on 12-1-5.
//  Copyright (c) 2012年 北京易天新动网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreTextParams : NSObject {
@public
    CTFontRef fontRef;
    
    CGFloat lineHeight;
    CGFloat lineSpace;
    CGFloat charSpace;
    CGFloat fontSize;
    
    CGRect visibleBounds;
    
    CTParagraphStyleSetting * settings;
    CTLineBreakMode lineBreakMode;
    CTParagraphStyleRef paragraphStyleRef;
}

@property (nonatomic, retain) NSString *fontName;
@property (nonatomic, retain) UIColor *foregroundColor;
@property (nonatomic, retain) UIColor *backgroundColor;
@property (nonatomic, retain) UIImageView *backgroundImageView;

- (void)updateParams;

@end
