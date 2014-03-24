//
//  DetailViewController.m
//  MobileFastFacts
//
//  Created by Mike Caterino on 12/3/13.
//  This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.

#import "KeywordDetailViewController.h"
#import "DFFRecentlyViewed.h"
#import "SettingsViewController.h"

@interface KeywordDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end

@implementation KeywordDetailViewController
@synthesize leftButtonItem;
@synthesize showToolbar;
// - (void)configureView{}

#pragma mark - Managing the detail item

- (void)setDetailItem:(NSInteger*)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

+ (NSString *)formatFileName:(NSInteger)n
{
    return [NSString stringWithFormat:@"ff_%.3d", n];
}

- (void)configureView
{
    showToolbar = TRUE;
    NSString *a = [NSString stringWithFormat:@"%@", self.detailItem];
    NSInteger b = [a integerValue];
    
    self.webView.delegate = self;
    self.navigationItem.leftBarButtonItem.title = @"";
    
    // Update the user interface for the detail item.
    if (self.detailItem >= 0) {
        NSString *urlString = [KeywordDetailViewController formatFileName:b];
        NSURL *url = [[NSBundle mainBundle] URLForResource:urlString withExtension:@".htm"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [self.webView loadRequest:request];
    }
}

// Change the Articles back button to WebView Back if the browser can go back.
- (void)webViewDidFinishLoad:(UIWebView *)thisWebView
{
    /*****
      The following three lines take the user's font size preference and modifies it to display as the same size as the example text.
      */
    NSInteger fontSize = [SettingsViewController getFontSizeValue]*20;
    NSString *jscript = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", fontSize];
    [self.webView stringByEvaluatingJavaScriptFromString:jscript];
    
	if(self.webView.canGoBack) {
        self.navigationItem.leftBarButtonItem = leftButtonItem;
        self.navigationItem.leftBarButtonItem.title = @"Back";
    }
    else {
        leftButtonItem = self.navigationItem.leftBarButtonItem;
        self.navigationItem.leftBarButtonItem = nil;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.delegate = self;
    [self.view addGestureRecognizer:doubleTap];
    
    [self configureView];
    
    /************************************
    DFFRecentlyViewed *rvqueue = [[DFFRecentlyViewed alloc] init];
    [rvqueue updateQueue: *(self.detailItem+1)];
     */
}
    
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
        return YES;
}
    
- (void) doubleTap:(UITapGestureRecognizer*)gesture {
    if(showToolbar) {
        showToolbar = !showToolbar;
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    else {
        showToolbar = !showToolbar;
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Back", @"Home");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
