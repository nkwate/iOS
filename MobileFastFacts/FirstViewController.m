//
//  HomeViewController.m
//  MobileFastFacts
//
//  Created by Mike Caterino on 4/16/2014.
//  This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.

#import "FirstViewController.h"
#import "TestFlight.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize VersionNumber = _VersionNumber;
@synthesize display;
@synthesize pageController;
@synthesize image1;
@synthesize image2;
@synthesize image3;
@synthesize image4;
@synthesize image5;
@synthesize defaults;

/*
 - (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
 {
 NSLog(@"HERE yo yo");
 if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
 NSLog(@"HERE yo yo 2");{
 
 [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
 }
 else {
 
 }
 }
 */

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    defaults = [NSUserDefaults standardUserDefaults];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Go to homeview if already viewed
    if([defaults integerForKey:@"firstRun"] == 1) {
        [self performSegueWithIdentifier:@"toHomeViewController" sender:self];
    }
    else {
        [TestFlight passCheckpoint:@"Started First View Controller"];
        
        // Mark that it has now been viewed.
        [defaults setInteger:1 forKey:@"firstRun"];
        [defaults synchronize];
        
        _VersionNumber.text = [@"V:" stringByAppendingString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
        
        UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
        rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
        [rightSwipe setNumberOfTouchesRequired:1];
        [self.view addGestureRecognizer:rightSwipe];
        
        UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe:)];
        leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
        [rightSwipe setNumberOfTouchesRequired:1];
        [self.view addGestureRecognizer:leftSwipe];
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
            image1 = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"first ipad" ofType:@".png"]]];
            image2 = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"second ipad" ofType:@".png"]]];
            image3 = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"third ipad" ofType:@".png"]]];
            image4 = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fourth ipad" ofType:@".png"]]];
            image5 = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fifth ipad" ofType:@".png"]]];        }
        else {
            image1 = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"first" ofType:@".png"]]];
            image2 = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"second" ofType:@".png"]]];
            image3 = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"third" ofType:@".png"]]];
            image4 = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fourth" ofType:@".png"]]];
            image5 = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"fifth" ofType:@".png"]]];
        }
        
        [display setImage:image1];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

// If the user swipes right, go back a page.
- (void)rightSwipe:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if(pageController.currentPage == 1) {
        pageController.currentPage = 0;
        [display setImage:image1];
    }
    else if(pageController.currentPage == 2) {
        pageController.currentPage = 1;
        [display setImage:image2];
    }
    else if(pageController.currentPage == 3) {
        pageController.currentPage = 2;
        [display setImage:image3];
    }
    else if(pageController.currentPage == 4) {
        pageController.currentPage = 3;
        [display setImage:image4];
    }
}

// If the user swipes left, go forward a page. If last page, go to HomeViewController.
- (void)leftSwipe:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if(pageController.currentPage == 0) {
        pageController.currentPage = 1;
        [display setImage:image2];
    }
    else if(pageController.currentPage == 1) {
        pageController.currentPage = 2;
        [display setImage:image3];
    }
    else if(pageController.currentPage == 2) {
        pageController.currentPage = 3;
        [display setImage:image4];
    }
    else if(pageController.currentPage == 3) {
        pageController.currentPage = 4;
        [display setImage:image5];
    }
    else if(pageController.currentPage == 4) {
        [TestFlight passCheckpoint:@"Viewed All of First View Conroller"];
        [self performSegueWithIdentifier:@"toHomeViewController" sender:self];
    }
}

- (IBAction)choosePage:(id)sender {
    if(pageController.currentPage == 0) {
        [display setImage:image1];
    }
    else if(pageController.currentPage == 1) {
        [display setImage:image2];
    }
    else if(pageController.currentPage == 2) {
        [display setImage:image3];
    }
    else if(pageController.currentPage == 3) {
        [display setImage:image4];
    }
    else if(pageController.currentPage == 4) {
        [display setImage:image5];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end