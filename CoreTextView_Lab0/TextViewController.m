//
//  CoreTextViewController.m
//  CoreTextView_Lab0
//
//  Created by Deheng Xu on 11-11-11.
//  Copyright 2011年 北京易天新动网络科技有限公司. All rights reserved.
//

#import "TextViewController.h"
#import "CoreTextView.h"
#import "TextView.h"
#import "TextScrollView.h"
#import "SimpleTextProcessor.h"
#import "SimpleTextParams.h"
#import "TextBaseView.h"
#import "OpenGLES_TextView.h"
#import "CoreTextProcessor.h"
#import "CoreTextParams.h"
#import "CoreTextHelper.h"

@implementation TextViewController

@synthesize currentTextView;
@synthesize scrollView;
@synthesize segmentCtrl;
@synthesize textViews;
@synthesize labelFontSize;
@synthesize filePath;
@synthesize timeTest;
@synthesize scrollViews;
@synthesize coreTextProcessor;
@synthesize fileName;

- (void)dealloc
{
    if (currentTextView) {
        [currentTextView release];
    }
    if (scrollView) {
        [scrollView release];
    }
    if (segmentCtrl) {
        [segmentCtrl release];
    }
    if (textViews) {
        [textViews release];
    }
    if (scrollViews) {
        [scrollViews release];
    }
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (coreTextProcessor == nil) {
            coreTextProcessor = [CoreTextProcessor new];
        }
        fileName = @"2";
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (textViews == nil) {
        textViews = [[NSArray alloc] initWithObjects:[TextView new], [CoreTextView new], [OpenGLES_TextView new], nil];
        [[textViews objectAtIndex:0] setBackgroundColor:[UIColor colorWithAlpha:255 Red:222 green:228 blue:234]];
        [[textViews objectAtIndex:1] setBackgroundColor:[UIColor colorWithAlpha:255 Red:222 green:228 blue:234]];
        [[textViews objectAtIndex:2] setBackgroundColor:[UIColor colorWithAlpha:255 Red:222 green:228 blue:234]];
    }
    if (segmentCtrl) {
        if (![[segmentCtrl allTargets] containsObject:self]) {
            [segmentCtrl addTarget:self action:@selector(segmentControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        }
        segmentCtrl.selectedSegmentIndex = 0;
        [self segmentControlValueChanged:segmentCtrl];
    }
    
    scrollView.scrollEnabled = YES;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    OUT_FUNCTION_NAME();
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    if (segmentCtrl) {
        [segmentCtrl removeTarget:self action:@selector(segmentControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    self.segmentCtrl = nil;
    self.currentTextView = nil;
    self.scrollView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%@  :%@", DEBUG_FUNCTION_NAME, [self.currentTextView classForCoder]);
    if ([currentTextView isKindOfClass:[TextView class]]) {
        SimpleTextProcessor * processor = [(TextView*)currentTextView processor];
        CGRect textFrame = CGRectZero;
        textFrame.origin.x = 10;
        textFrame.origin.y = 10;
        textFrame.size.width = self.view.frame.size.width - textFrame.origin.x * 2.0f;
        textFrame.size.height = self.view.frame.size.height - textFrame.origin.y * 2.0f;
        processor.params.visibleBounds = textFrame;
        
        [processor textLinesFromRange:NSMakeRange(0, processor.text.length) OfString:processor.text inRect:textFrame UsingFont:processor.params.uiFont LineBreakMode:UILineBreakModeCharacterWrap IsForward:YES];
    }
//    if ([self.currentTextView respondsToSelector:@selector(loadText:)]) {
//        NSString * fileContent = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@""] encoding:NSUTF16LittleEndianStringEncoding error:nil] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        fileContent = [fileContent stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
//        if ([self.currentTextView isKindOfClass:[CoreTextView class]]) {
//            [(CoreTextView*)currentTextView loadText:fileContent];
//        }else {
//            [self.currentTextView loadText:fileContent];
//            [currentTextView setNeedsDisplay];
//        }
//    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (void)onClick_Reload:(id)sender
{
    if ([self.currentTextView isKindOfClass:[TextBaseView class]]) {
        id tv = self.currentTextView;
        self.labelFontSize.text = [NSString stringWithFormat:@"%f", [tv fontSize]];
        [self.currentTextView setNeedsDisplay];
    }
}

- (void)onClick_DecreaseFontSize:(id)sender
{
    if ([self.currentTextView isKindOfClass:[TextBaseView class]]) {
        id tv = self.currentTextView;
        if ([tv fontSize] > 5) {
            [tv setFontSize:[tv fontSize] - 1.0f];
            
            if ([currentTextView isKindOfClass:[CoreTextView class]]) {
                CoreTextView * ctv = (CoreTextView*)currentTextView;
                ctv.coreTextProcessor.coreTextParams->fontSize -= 1.0f;
                [ctv.coreTextProcessor.coreTextParams updateParams];
            }else if ([currentTextView isKindOfClass:[TextView class]]) {
                [((TextView*)tv).processor updateParams];
            }
            
            if ([tv respondsToSelector:@selector(updateTextParams)]) {
                [tv updateTextParams];
            }
            
            if ([tv respondsToSelector:@selector(reloadText)]) {
                [tv reloadText];
            }
            
            self.labelFontSize.text = [NSString stringWithFormat:@"%f", [tv fontSize]];
            
            if ([currentTextView isKindOfClass:[TextView class]]) {
                [tv setNeedsDisplay];                
            }
        }
    }else if ([self.currentTextView isKindOfClass:[TextView class]]) {
        TextView * txtView = (TextView*)self.currentTextView;
        if (txtView.processor.params.fontSize > 5) {
            txtView.processor.params.fontSize -= 1.0f;
            [txtView setNeedsDisplay];
        }
    }
}

- (void)onclick_IncreaseFontSize:(id)sender
{
    if ([self.currentTextView isKindOfClass:[TextBaseView class]]) {
        id tv = self.currentTextView;
        if ([tv fontSize] < 30) {
            [tv setFontSize:[tv fontSize] + 1.0f];
            if ([currentTextView isKindOfClass:[CoreTextView class]]) {
                CoreTextView * ctv = (CoreTextView*)currentTextView;
                ctv.coreTextProcessor.coreTextParams->fontSize += 1.0f;
                [ctv.coreTextProcessor.coreTextParams updateParams];
            }else if ([currentTextView isKindOfClass:[TextView class]]) {
                [((TextView*)tv).processor updateParams];
            }

            if ([tv respondsToSelector:@selector(updateTextParams)]) {
                [tv updateTextParams];
            }
            if ([tv respondsToSelector:@selector(reloadText)]) {
                [tv reloadText];
            }
            self.labelFontSize.text = [NSString stringWithFormat:@"%f", [tv fontSize]];
            
            if ([currentTextView isKindOfClass:[TextView class]]) {
                [tv setNeedsDisplay];                
            }
        }
    }else if ([self.currentTextView isKindOfClass:[TextView class]]) {
        TextView * txtView = (TextView*)self.currentTextView;
        if (txtView.processor.params.fontSize < 30) {
            txtView.processor.params.fontSize += 1.0f;
            [txtView setNeedsDisplay];
        }
    }
}

- (void)onclick_Previous:(id)sender
{
    if ([self.currentTextView isKindOfClass:[CoreTextView class]]) {
        CoreTextProcessor * processor = [(CoreTextView*)self.currentTextView coreTextProcessor];
        [processor loadPage:processor.currentPage - 1 InFrame:self.view.frame];
        [currentTextView setNeedsDisplay];
    }else if([currentTextView isKindOfClass:[TextView class]]) {
        SimpleTextProcessor * processor = [(TextView*)currentTextView processor];
        
    }
}

- (void)onClick_Next:(id)sender
{
    if ([self.currentTextView isKindOfClass:[CoreTextView class]]) {
        CoreTextProcessor * processor = [(CoreTextView*)self.currentTextView coreTextProcessor];
        [processor loadPage:processor.currentPage + 1 InFrame:self.view.frame];
        [currentTextView setNeedsDisplay];
    }else if([currentTextView isKindOfClass:[TextView class]]) {
        SimpleTextProcessor * processor = [(TextView*)currentTextView processor];
        [processor loadNextPage];
        [self.view setNeedsDisplay];
    }

}

- (void)onClick_IncreaseLineSpace:(id)sender
{
    if ([self.currentTextView isKindOfClass:[CoreTextView class]]) {
        CoreTextProcessor * processor = [(CoreTextView*)self.currentTextView coreTextProcessor];
        processor.coreTextParams->lineSpace += 1.0f;
        [processor.coreTextParams updateParams];
    }
}

- (void)onClick_DecreaseLineSpace:(id)sender
{
    if ([self.currentTextView isKindOfClass:[CoreTextView class]]) {
        CoreTextProcessor * processor = [(CoreTextView*)self.currentTextView coreTextProcessor];
        if (processor.coreTextParams->lineSpace - 1.0f > 0) {
            processor.coreTextParams->lineSpace -= 1.0f;
            [processor.coreTextParams updateParams];
        }
    }
}

- (void)segmentControlValueChanged:(id)sender
{
    NSLog(@"%@,  %u", DEBUG_FUNCTION_NAME, segmentCtrl.selectedSegmentIndex);
    
    ((UIView*)[textViews objectAtIndex:segmentCtrl.selectedSegmentIndex]).frame = self.currentTextView.frame;
    [currentTextView removeFromSuperview];
    self.currentTextView = [textViews objectAtIndex:segmentCtrl.selectedSegmentIndex];
    [scrollView addSubview:currentTextView];
    
    NSString * fileContent = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@""] encoding:NSUTF16LittleEndianStringEncoding error:nil] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    fileContent = [fileContent stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
    if ([currentTextView isKindOfClass:[TextView class]]) {
        [currentTextView loadText:fileContent];
        [currentTextView setNeedsDisplay];
    }else if ([currentTextView isKindOfClass:[CoreTextView class]]) {
        [scrollView setScrollEnabled:YES];
        [currentTextView loadText:fileContent];
        [currentTextView reloadText];
        [currentTextView setNeedsDisplay];
    }else if ([currentTextView isKindOfClass:[OpenGLES_TextView class]]) {
        
    }
}

#pragma UIScrollView delegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"耗时 :%f", ([[NSDate date] timeIntervalSince1970] - timeTest.timeIntervalSince1970));
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.timeTest = [NSDate date];
}

@end
