//
//  CotMViewController.m
//  MobileFastFacts
//
//  Created by Mike Caterino in February 2014.
//  This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.

#import "CotMViewController.h"
#import "DFFRecentlyViewed.h"
#import "TestFlight.h"

@interface CotMViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end

@implementation CotMViewController
@synthesize webView;
@synthesize leftButtonItem;
@synthesize previousButton;
@synthesize nextButton;
@synthesize showToolbar;
@synthesize navBar;

NSInteger MAXCOTMNUM = 79;

#pragma mark - Managing the detail item

- (void)configureView
{
    showToolbar = TRUE;
    self.webView.delegate = self;
    self.navigationItem.leftBarButtonItem.title = @"";
    
    self.detailItem = MAXCOTMNUM;
    
    NSString *urlString = [NSString stringWithFormat:@"%li", (long)MAXCOTMNUM];
    NSURL *url = [[NSBundle mainBundle] URLForResource:urlString withExtension:@".pdf"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
    nextButton.enabled = NO;
}

// Change the back button title to nothing if first page, otherwise display "Back".
- (void)webViewDidFinishLoad:(UIWebView *)thisWebView
{
	if(webView.canGoBack) {
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
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [TestFlight passCheckpoint:@"Viewed Case of the Month"];
	// Do any additional setup after loading the view, typically from a nib.
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.delegate = self;
    [self.view addGestureRecognizer:doubleTap];
    
    [self configureView];
    //*********************************
    //  DFFRecentlyViewed *rvqueue = [[DFFRecentlyViewed alloc] init];
    //[rvqueue updateQueue: self.detailItem+1];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void) doubleTap:(UITapGestureRecognizer*)gesture {
    if(showToolbar) {
        showToolbar = !showToolbar;
        //[[self navigationController] setNavigationBarHidden:YES animated:YES];
        [self.navBar setHidden:YES];
        [UIView animateWithDuration:0.3 animations:^{
            webView.frame = CGRectMake(webView.frame.origin.x, webView.frame.origin.y, webView.frame.size.width, webView.frame.size.height + 88);
        }];
        //[[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    else {
        showToolbar = !showToolbar;
        //[[self navigationController] setNavigationBarHidden:NO animated:YES];
        [self.navBar setHidden:NO];
        //[[UIApplication sharedApplication] setStatusBarHidden:NO];
        
    }
}

- (IBAction)previousButtonClicked:(id)sender {
    if(self.detailItem > 0) {
        
        if (!nextButton.isEnabled) {
            nextButton.enabled = YES;
        }
        
        self.detailItem = self.detailItem-1;
        
        NSString *urlString = [NSString stringWithFormat:@"%li", (long)self.detailItem];
        NSURL *url = [[NSBundle mainBundle] URLForResource:urlString withExtension:@".pdf"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [webView loadRequest:request];
        
    }
    
    if (self.detailItem == 1) {
        previousButton.enabled = NO;
    }
}

- (IBAction)nextButtonClicked:(id)sender {
    
    if(self.detailItem < MAXCOTMNUM) {
        if(!previousButton.isEnabled){
            previousButton.enabled = YES;
        }
        
        self.detailItem = self.detailItem+1;
        
        NSString *urlString = [NSString stringWithFormat:@"%li", (long)self.detailItem];
        NSURL *url = [[NSBundle mainBundle] URLForResource:urlString withExtension:@".pdf"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [webView loadRequest:request];
    }
    
    if(self.detailItem == MAXCOTMNUM) {
        nextButton.enabled = NO;
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
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = nil;
}

@end
