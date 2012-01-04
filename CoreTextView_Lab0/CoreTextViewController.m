//
//  CoreTextViewController.m
//  CoreTextView_Lab0
//
//  Created by Deheng Xu on 11-11-11.
//  Copyright 2011年 北京易天新动网络科技有限公司. All rights reserved.
//

#import "CoreTextViewController.h"
#import "CoreTextView.h"
#import "TextView.h"
#import "TextScrollView.h"
#import "SimpleTextProcessor.h"
#import "TextBaseView.h"
#import "OpenGLES_TextView.h"

@implementation CoreTextViewController

@synthesize currentTextView;
@synthesize scrollView;
@synthesize segmentCtrl;
@synthesize textViews;
@synthesize labelFontSize;

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
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
        segmentCtrl.selectedSegmentIndex = 1;
    }

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
    if ([self.currentTextView respondsToSelector:@selector(loadText:)]) {
        NSString * fileContent = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"2" ofType:@""] encoding:NSUTF16LittleEndianStringEncoding error:nil] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self.currentTextView loadText:fileContent];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
            if ([tv respondsToSelector:@selector(updateCoreTextParams)]) {
                [tv updateCoreTextParams];
            }
            if ([tv respondsToSelector:@selector(reloadText)]) {
                [tv reloadText];
            }
            self.labelFontSize.text = [NSString stringWithFormat:@"%f", [tv fontSize]];
        }
    }
}

- (void)onclick_IncreaseFontSize:(id)sender
{
    if ([self.currentTextView isKindOfClass:[TextBaseView class]]) {
        id tv = self.currentTextView;
        if ([tv fontSize] < 30) {
            [tv setFontSize:[tv fontSize] + 1.0f];
            if ([tv respondsToSelector:@selector(updateCoreTextParams)]) {
                [tv updateCoreTextParams];
            }
            if ([tv respondsToSelector:@selector(reloadText)]) {
                [tv reloadText];
            }
            self.labelFontSize.text = [NSString stringWithFormat:@"%f", [tv fontSize]];
        }
    }
}

- (void)segmentControlValueChanged:(id)sender
{
    NSLog(@"%@,  %u", DEBUG_FUNCTION_NAME, segmentCtrl.selectedSegmentIndex);
    
    ((UIView*)[textViews objectAtIndex:segmentCtrl.selectedSegmentIndex]).frame = self.currentTextView.frame;
    [currentTextView removeFromSuperview];
    currentTextView = [textViews objectAtIndex:segmentCtrl.selectedSegmentIndex];
    [scrollView addSubview:currentTextView];
    
    if ([currentTextView respondsToSelector:@selector(loadText:)]) {
        NSString * contents = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"2" ofType:@""] encoding:NSUTF16LittleEndianStringEncoding error:nil] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [currentTextView loadText:contents];
        [currentTextView setNeedsDisplay];
    }

}

@end
