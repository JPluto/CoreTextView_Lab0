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
- (void)loadText:(NSString*)aString;

@end

@interface TextBaseView : UIView <TextBaseDelegate>

@property (nonatomic) CGFloat fontSize;
@property (nonatomic) CGFloat lineSpace;
@property (nonatomic, retain) NSString * text;

@end
