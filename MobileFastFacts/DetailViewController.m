//
//  DetailViewController.m
//  MobileFastFacts
//
//  Created by Jeff Jackson on 9/24/13.
//  Copyright (c) 2013 Duquesne University. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@end

@implementation DetailViewController
// - (void)configureView{}

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

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem >= 0) {
            //NSURL *url = [[NSURL alloc] initWithString:@"ff_001.htm"];
        NSString *urlString;
        if (self.detailItem < 9) {
             urlString = [NSString stringWithFormat:@"ff_00%d", self.detailItem+1];
        }
        else if (self.detailItem < 99) {
             urlString = [NSString stringWithFormat:@"ff_0%d", self.detailItem+1];           
        }
        else {
             urlString = [NSString stringWithFormat:@"ff_%d", self.detailItem+1];
        }
        // NSURL *url = [[NSBundle mainBundle] URLForResource:@"ff_001" withExtension:@".htm"];
        NSURL *url = [[NSBundle mainBundle] URLForResource:urlString withExtension:@".htm"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [self.webView loadRequest:request];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
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
