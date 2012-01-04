//
//  CoreTextViewController.h
//  CoreTextView_Lab0
//
//  Created by Deheng Xu on 11-11-11.
//  Copyright 2011年 北京易天新动网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TextScrollView;
@class TextBaseView;

@interface CoreTextViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, retain) IBOutlet TextBaseView * currentTextView;
@property (nonatomic, retain) IBOutlet TextScrollView * scrollView;
@property (nonatomic, retain) IBOutlet UISegmentedControl * segmentCtrl;
@property (nonatomic, retain) IBOutlet UILabel * labelFontSize;
@property (nonatomic, retain) NSArray * textViews;

- (IBAction)onClick_Reload:(id)sender;
- (IBAction)onClick_DecreaseFontSize:(id)sender;
- (IBAction)onclick_IncreaseFontSize:(id)sender;
- (void)segmentControlValueChanged:(id)sender;


@end
