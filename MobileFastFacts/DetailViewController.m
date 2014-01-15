//
//  DetailViewController.m
//  MobileFastFacts
//
//  Created by Jeff Jackson on 9/24/13.
//  Copyright (c) 2013 Duquesne University. All rights reserved.
//

#import "DetailViewController.h"
#import "DFFRecentlyViewed.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end

@implementation DetailViewController
@synthesize webView;
@synthesize leftButtonItem;

#pragma mark - Managing the detail item

- (void)setDetailItem:(NSInteger)newDetailItem
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
    // Update the user interface for the detail item.
    
    self.webView.delegate = self;   // Allows me to controll the WebView's methods.
    
    if (self.detailItem >= 0) {
        NSString *urlString = [DetailViewController formatFileName:self.detailItem+1];
        NSURL *url = [[NSBundle mainBundle] URLForResource:urlString withExtension:@".htm"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [webView loadRequest:request];
    }
    self.navigationItem.leftBarButtonItem.title = @"";
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
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self configureView];
    //*********************************
  //  DFFRecentlyViewed *rvqueue = [[DFFRecentlyViewed alloc] init];
    //[rvqueue updateQueue: self.detailItem+1];

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
