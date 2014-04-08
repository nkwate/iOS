//
//  DetailViewController.m
//  MobileFastFacts
//
//  Created by FA13-COSC 445W-01 on 9/24/13 with further revisions from Mike Caterino.
//  This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.


#import "DetailViewController.h"
#import "DFFRecentlyViewed.h"
#import "SettingsViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end

@implementation DetailViewController
@synthesize webView;
@synthesize leftButtonItem;
@synthesize previousArticleButton;
@synthesize nextArticleButton;
@synthesize shareButton;
@synthesize showToolbar;
@synthesize navBar;

@synthesize documentController;

NSInteger MAXARTICLENUM = 272;
#pragma mark - Managing the detail item

- (IBAction)shareClicked:(id)sender{
    [self openDocumentsIn];
}

-(void) openDocumentsIn {
    self.documentController = [UIDocumentInteractionController interactionControllerWithURL:[[NSBundle mainBundle] URLForResource:[DetailViewController formatFileName:self.detailItem+1] withExtension:@".htm"]];
    documentController.delegate = self;
    documentController.UTI = @"public.text";
    if(![documentController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"You don't have an app installed that can save HTM files." delegate:self cancelButtonTitle:@"Close." otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (IBAction)emailClicked:(id)sender {
        NSString *emailTitle = @"A Fast Fact Article was Shared With You";
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        
        NSString *filename = [NSString stringWithFormat: @"%@.htm", [DetailViewController formatFileName:self.detailItem+1]];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:@".htm"];
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        
        [mc addAttachmentData:fileData mimeType:@"text/html" fileName:filename];
        [self presentViewController:mc animated:YES completion:NULL];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)code error:(NSError *)error
{
    switch (code)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Send failure %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

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


- (IBAction)previousClicked:(id)sender {
    // Only execute when in article ranage
    if(_detailItem > 0) {
        _detailItem = _detailItem-1;
        NSString *urlString = [DetailViewController formatFileName:self.detailItem+1];
        NSURL *url = [[NSBundle mainBundle] URLForResource:urlString withExtension:@".htm"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [webView loadRequest:request];
    }
}

- (IBAction)nextClicked:(id)sender {
    // Only execute when in article range
    if(_detailItem < MAXARTICLENUM-1) {
        _detailItem = _detailItem+1;
        
        NSString *urlString = [DetailViewController formatFileName:self.detailItem+1];
        NSURL *url = [[NSBundle mainBundle] URLForResource:urlString withExtension:@".htm"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [webView loadRequest:request];
    }
}


+ (NSString *)formatFileName:(NSInteger)n
{
    return [NSString stringWithFormat:@"ff_%.3d", n];
}

- (void)configureView
{
    showToolbar = true;
    
    self.webView.delegate = self;   // Allows me to controll the WebView's methods.
    
    // Update the user interface for the detail item.
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
    /*****
     The following three lines take the user's font size preference and modifies it to display as the same size as the example text.
     */
    NSInteger fontSize = [SettingsViewController getFontSizeValue]*20;
    NSString *jscript = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", fontSize];
    [webView stringByEvaluatingJavaScriptFromString:jscript];
    
    /*****
     The following five lines of code update the detail item everytime a page is loaded so that the next and previous button are relative to the current article in the view.
     */
    NSString *detail =  (@"%@", self.webView.request.URL.absoluteString);
    detail = [detail substringToIndex:[detail length] - 4];
    detail = [detail substringFromIndex:[detail length] - 3];
    NSInteger detailItm = [detail integerValue];
    self.detailItem = detailItm-1;
    
    // Enable the back button if there is a page to go back to. Otherwise, stay disabled.
	if(webView.canGoBack) {
        self.navigationItem.leftBarButtonItem = leftButtonItem;
        self.navigationItem.leftBarButtonItem.title = @"Back";
    }
    else {
        leftButtonItem = self.navigationItem.leftBarButtonItem;
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    // Enable or disable the next and previous button depending on the article number.
    if (self.detailItem == 0) {
        previousArticleButton.enabled = NO;
        nextArticleButton.enabled = YES;
    }
    else if (self.detailItem == MAXARTICLENUM-1) {
        nextArticleButton.enabled = NO;
        previousArticleButton.enabled = YES;
    }
    else {
        previousArticleButton.enabled = YES;
        nextArticleButton.enabled = YES;
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
    NSLog(@"%ld", (long)_detailItem);
    
    
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
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
        [self.navBar setHidden:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [UIView animateWithDuration:0.3 animations:^{
            self.webView.frame = CGRectMake(self.webView.frame.origin.x, self.webView.frame.origin.y, self.webView.frame.size.width, self.webView.frame.size.height + 88);
        }];
    }
    else {
        showToolbar = !showToolbar;
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
        [self.navBar setHidden:NO];
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
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = nil;
}

@end
