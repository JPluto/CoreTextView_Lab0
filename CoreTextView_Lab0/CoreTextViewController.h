//
//  CoreTextViewController.h
//  CoreTextView_Lab0
//
//  Created by Deheng Xu on 11-11-11.
//  Copyright 2011年 北京易天新动网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextScrollView;

@interface CoreTextViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, retain) IBOutlet UIView * currentTextView;
@property (nonatomic, retain) IBOutlet TextScrollView * scrollView;
@property (nonatomic, retain) IBOutlet UISegmentedControl * segmentCtrl;

- (CFMutableAttributedStringRef) loadAttributedStringFromFile:(NSString *)filePath;

- (IBAction)onClick_Reload:(id)sender;
- (IBAction)onClick_DecreaseFontSize:(id)sender;
- (IBAction)onclick_IncreaseFontSize:(id)sender;
- (void)segmentControlValueChanged:(id)sender;

@end
