//
//  CoreTextView_Lab0AppDelegate.h
//  CoreTextView_Lab0
//
//  Created by Deheng Xu on 11-11-11.
//  Copyright 2011年 北京易天新动网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextViewController;

@interface CoreTextView_Lab0AppDelegate : UIResponder <UIApplicationDelegate>

@property (retain, nonatomic) UIWindow *window;
@property (retain, nonatomic) TextViewController * ctvc;

- (void)onClick_reloadText:(id)sender;

@end
