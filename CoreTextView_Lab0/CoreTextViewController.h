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
@class CoreTextProcessor;

@interface CoreTextViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, retain) NSDate * timeTest;
@property (nonatomic, retain) IBOutlet TextBaseView * currentTextView;
@property (nonatomic, retain) IBOutlet TextScrollView * scrollView;
@property (nonatomic, retain) IBOutlet UISegmentedControl * segmentCtrl;
@property (nonatomic, retain) IBOutlet UILabel * labelFontSize;

@property (nonatomic, retain) NSArray * textViews;
@property (nonatomic, retain) NSString * filePath;
@property (nonatomic, retain) NSArray * scrollViews;
@property (nonatomic, retain) CoreTextProcessor * coreTextProcessor;
@property (nonatomic, retain) NSString * fileName;

- (IBAction)onClick_Reload:(id)sender;
- (IBAction)onClick_DecreaseFontSize:(id)sender;
- (IBAction)onclick_IncreaseFontSize:(id)sender;
- (IBAction)onclick_Previous:(id)sender;
- (IBAction)onClick_Next:(id)sender;
- (IBAction)onClick_IncreaseLineSpace:(id)sender;
- (IBAction)onClick_DecreaseLineSpace:(id)sender;

- (void)segmentControlValueChanged:(id)sender;


@end
