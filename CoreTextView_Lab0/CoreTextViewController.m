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

@implementation CoreTextViewController

@synthesize currentTextView;
@synthesize scrollView;
@synthesize segmentCtrl;

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
    if (segmentCtrl) {
        [segmentCtrl addTarget:self action:@selector(segmentControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
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
    if ([self.currentTextView isKindOfClass:[CoreTextView class]]) {
        CFMutableAttributedStringRef cfattstringref = [self loadAttributedStringFromFile:[[NSBundle mainBundle] pathForResource:@"2" ofType:nil]];
        CoreTextView * ctv = (CoreTextView*)self.currentTextView;
        ctv->cfAttrStringRef = (CFMutableAttributedStringRef)CFRetain(cfattstringref);
        [ctv loadVisibleTextForCFRange:CFRangeMake(ctv->startGlyphIndex + ctv->totalGlyphCount, 0)];
    }else if ([self.currentTextView isKindOfClass:[TextView class]]) {
        TextView * textView = (TextView*)self.currentTextView;
        [textView setText:[[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"1" ofType:@""] encoding:NSUTF16LittleEndianStringEncoding error:nil] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        textView->cgFontRef = CGFontCreateWithFontName((CFStringRef)@"Arial");

    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (CFMutableAttributedStringRef)loadAttributedStringFromFile:(NSString *)filePath
{
    NSLog(@"filepath:%@", filePath);
    NSError * error = nil;
    
    NSString * contents = [[NSString stringWithContentsOfFile:filePath encoding:NSUTF16StringEncoding error:&error] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    contents = [contents stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
    //NSLog(@"contents = %@", contents);
    
    NSMutableAttributedString * attStr = nil;
    UIFont * font = [UIFont fontWithName:@"System" size:20.0];
    
    attStr = [[[NSMutableAttributedString alloc] initWithString:contents attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, (NSString *)kCTFontAttributeName, nil]] autorelease];
    
    [attStr addAttribute:(id)kCTForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 100)];

    CFMutableAttributedStringRef attrString = (CFMutableAttributedStringRef) attStr;
    
    return attrString;
}

- (void)onClick_Reload:(id)sender
{
    if ([self.currentTextView isKindOfClass:[TextView class]]) {
        [self.currentTextView setNeedsDisplay];
    }
}

- (void)onClick_DecreaseFontSize:(id)sender
{
    if ([self.currentTextView isKindOfClass:[TextView class]]) {
        TextView * tv = (TextView*)self.currentTextView;
        if (tv.fontSize > 10) {
            [tv setFontSize:tv.fontSize - 1];
            [tv setNeedsDisplay];
        }
    }
    
}

- (void)onclick_IncreaseFontSize:(id)sender
{
    if ([self.currentTextView isKindOfClass:[TextView class]]) {
        TextView * tv = (TextView*)self.currentTextView;
        if (tv.fontSize < 30) {
            [tv setFontSize:tv.fontSize + 1];
            [tv setNeedsDisplay];
        }
    }
}

- (void)segmentControlValueChanged:(id)sender
{
    NSLog(@"%@", DEBUG_FUNCTION_NAME);
    
}

@end
