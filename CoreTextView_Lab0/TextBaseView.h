//
//  TextBase.h
//  CoreTextView_Lab0
//
//  Created by Deheng Xu on 11-12-27.
//  Copyright (c) 2011年 北京易天新动网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextBaseDelegate <NSObject>

@optional

- (void)reloadText;
- (void)loadText:(NSString*)aString;
- (void)refreshText:(NSString*)aString;
- (void)asynLoadText:(NSString *)aString;

@end

@interface TextBaseView : UIView <TextBaseDelegate>
{
    CGFloat fontSize;
    CGFloat lineSpace;
    CGFloat lineHeight;
    NSString * fontName;
    NSString * text;
    NSInteger pageCount;
}

@property (nonatomic) CGFloat fontSize;
@property (nonatomic) CGFloat lineSpace;
@property (nonatomic) CGFloat lineHeight;
@property (nonatomic, retain) NSString * fontName;
@property (nonatomic, retain) NSString * text;
@property (nonatomic) NSInteger pageCount;

- (CTFontRef)CreateItalicCTFont;
- (CTFontRef)CreateBoldCTFont;
- (CTFontRef)CreateNormalCTFont;

@end
