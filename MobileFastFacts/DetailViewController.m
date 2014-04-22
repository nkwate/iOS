//
//  DetailViewController.m
//  MobileFastFacts
//
//  Created by FA13-COSC 445W-01 on 9/24/13 with further revisions from Mike Caterino.
//  This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.


#import "DetailViewController.h"
#import "DFFRecentlyViewed.h"
#import "SettingsViewController.h"
#import "TestFlight.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end

@implementation DetailViewController
@synthesize webView;
@synthesize leftButtonItem;
@synthesize previousArticleButton;
@synthesize nextArticleButton;
@synthesize showToolbar;
@synthesize navBar;
@synthesize searchResult;
@synthesize emailIcon;
@synthesize backButton;
@synthesize fontSize;

@synthesize documentController;

NSInteger MAXARTICLENUM = 272;
#pragma mark - Managing the detail item

- (IBAction)emailClicked:(id)sender {
    [TestFlight passCheckpoint:@"Email Clicked"];

    NSString *emailTitle = @"A Fast Fact Article was Shared With You";
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    
    NSString *filename = [NSString stringWithFormat: @"%@", [DetailViewController formatFileName:self.detailItem+1]];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:@".htm"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    [mc setMessageBody:@"\n\n\nDownload Fast Facts for iOS today. http://tflig.ht/1cAHhxT" isHTML:NO];
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

- (void)setDetailItem:(NSInteger)newDetailItem highlight:(NSString *)newSearchResult
{
    NSLog(@"%@ set %@", newSearchResult, self);
    if(self.searchResult != newSearchResult) {
        self.searchResult = newSearchResult;
        self.searchResult = newSearchResult;
    }
    
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
    return [NSString stringWithFormat:@"ff_%.3ld", (long)n];
}

- (void)configureView
{
    showToolbar = true;
    
    self.webView.delegate = self;   // Allows me to controll the WebView's methods.
    
    // Update the user interface for the detail item.
    if (self.detailItem >= 0) {
        NSLog(@"config detail %@ %@", self.searchResult, self);
        NSString *urlString = [DetailViewController formatFileName:self.detailItem+1];
        NSURL *url = [[NSBundle mainBundle] URLForResource:urlString withExtension:@".htm"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [webView loadRequest:request];
    }
}

// Change the back button title to nothing if first page, otherwise display "Back".
- (void)webViewDidFinishLoad:(UIWebView *)thisWebView
{
    NSLog(@"didFinish %@ %@", self.searchResult, self);
    /*****
     The following lines take the user's font size preference and modifies it to display as the same size as the example text. It also modifies the css based on choice in settings.
     */
    fontSize = [SettingsViewController getFontSizeValue]*20;
    NSInteger cssValue = [SettingsViewController getStyleSheet];
    NSString *jscript;
    
    if(cssValue == 1) {
        jscript = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%ld%%'; document.getElementsByTagName('body')[0].style.color= '#000000'; document.getElementsByTagName('body')[0].style.backgroundColor='#FFFFFF'", (long)fontSize];
    }
    else if(cssValue == 2) {
        jscript = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%ld%%'; document.getElementsByTagName('body')[0].style.color= '#FFFFFF'; document.getElementsByTagName('body')[0].style.backgroundColor='#000000'", (long)fontSize];
    }
    else if(cssValue == 3){
        jscript = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%ld%%'; document.getElementsByTagName('body')[0].style.color= '#0000000'; document.getElementsByTagName('body')[0].style.backgroundColor='#FFEFE6'", (long)fontSize];
    }
    else{
        jscript = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%ld%%'", (long)fontSize];
        NSLog(@"There was an error getting the css value in method webViewDidFinishLoad in DetailViewController.m. cssValue=%ld",(long)cssValue);
    }
    [webView stringByEvaluatingJavaScriptFromString:jscript];
    
    NSLog(@"%@ search %@", self.searchResult, self);
    NSLog(@"%lu", (unsigned long)[self.searchResult length]);
    if([self.searchResult length] != 0) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"UIWebViewSearch" ofType:@"js"];
        NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [webView stringByEvaluatingJavaScriptFromString:jsCode];
        
        NSString *startSearch = [NSString stringWithFormat:@"uiWebview_HighlightAllOccurencesOfString('%@')",self.searchResult];
        [webView stringByEvaluatingJavaScriptFromString:startSearch];
    }
    
    /*****
     The following five lines of code update the detail item everytime a page is loaded so that the next and previous button are relative to the current article in the view.
     */
    NSString *detail =  self.webView.request.URL.absoluteString;
    detail = [detail substringToIndex:[detail length] - 4];
    detail = [detail substringFromIndex:[detail length] - 3];
    NSInteger detailItm = [detail integerValue];
    self.detailItem = detailItm-1;
    
    // Enable the back button if there is a page to go back to. Otherwise, stay disabled.
	if(webView.canGoBack) {
        backButton.title = @"Go Back";
    }
    else {
        if([backButton.title = [[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2] title] compare:@""] == 0)
            backButton.title = @"Home";
    }
    
    // Enable or disable the next and previous button depending on the article number.
    if (self.detailItem == 0) {
        emailIcon.enabled = YES;
        previousArticleButton.enabled = NO;
        nextArticleButton.enabled = YES;
    }
    else if (self.detailItem == MAXARTICLENUM-1) {
        emailIcon.enabled = YES;
        nextArticleButton.enabled = NO;
        previousArticleButton.enabled = YES;
    }
    else if(self.detailItem == -1) {
        emailIcon.enabled = NO;
        previousArticleButton.enabled = NO;
        nextArticleButton.enabled = NO;
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
    self.navigationController.navigationBarHidden = NO;
	// Do any additional setup after loading the view, typically from a nib.

    leftButtonItem = self.navigationItem.leftBarButtonItem;
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.delegate = self;
    [self.view addGestureRecognizer:doubleTap];
    
    UIPinchGestureRecognizer *pinchToZoom = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchToZoom:)];
    pinchToZoom.delegate = self;
    [self.view addGestureRecognizer:pinchToZoom];
    
    [self configureView];
    //*********************************
    //  DFFRecentlyViewed *rvqueue = [[DFFRecentlyViewed alloc] init];
    //[rvqueue updateQueue: self.detailItem+1];
    
}

- (IBAction)backPressed:(id)sender {
    if(webView.canGoBack) {
        [webView goBack];
        NSString *detail =  self.webView.request.URL.absoluteString;
        detail = [detail substringToIndex:[detail length] - 4];
        detail = [detail substringFromIndex:[detail length] - 3];
        NSInteger detailItm = [detail integerValue];
        self.detailItem = detailItm-1;
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void) pinchToZoom:(UIPinchGestureRecognizer*)gesture {
    if (gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateEnded) {
        if (gesture.scale*fontSize <= 240 && gesture.scale*fontSize >= 60) {
            NSString *jscript = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%%'", gesture.scale*fontSize];
            [webView stringByEvaluatingJavaScriptFromString:jscript];
        }
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        if (gesture.scale*fontSize <= 240 && gesture.scale >= 60) {
            NSLog(@"%f", gesture.scale*fontSize/20);
            
            [defaults setFloat:gesture.scale*fontSize/20 forKey:@"fontSizeValue"];
        }
        else if (gesture.scale*fontSize > 240){
            [defaults setFloat:12 forKey:@"fontSizeValue"];
        }
        else {
            [defaults setFloat:3 forKey:@"fontSizeValue"];
        }
        [defaults synchronize];
    }
}

- (void) doubleTap:(UITapGestureRecognizer*)gesture {
    if(showToolbar) {
        showToolbar = !showToolbar;
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
        [self.navBar setHidden:YES];
        //[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
        [UIView animateWithDuration:0.3 animations:^{
            self.webView.frame = CGRectMake(self.webView.frame.origin.x, self.webView.frame.origin.y, self.webView.frame.size.width, self.webView.frame.size.height + 88);
        }];
    }
    else {
        showToolbar = !showToolbar;
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
        [self.navBar setHidden:NO];
        //[[UIApplication sharedApplication] setStatusBarHidden:NO];
        [UIView animateWithDuration:0.3 animations:^{
            self.webView.frame = CGRectMake(self.webView.frame.origin.x, self.webView.frame.origin.y, self.webView.frame.size.width, self.webView.frame.size.height);
        }];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view


@end
