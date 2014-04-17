//
//  SettingsViewController.m
//  MobileFastFacts
//
//  Created by Mike Caterino on 3/24/2014.
//  This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.

#import "FeedbackViewController.h"
#import "TestFlight.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

@synthesize versionNumber = _versionNumber;
@synthesize submitBtn = _submitBtn;
@synthesize feedbackField = _feedbackField;

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
    self.navigationItem.hidesBackButton = YES;
    
    // Add the version number to the Settings View screen.
    _versionNumber.text = [@"Version " stringByAppendingString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
    [super viewDidLoad];
}

- (IBAction)submitClicked:(id)sender {
    if(_feedbackField.text) {
        [TestFlight submitFeedback:_feedbackField.text];
        [self performSegueWithIdentifier:[[NSString stringWithFormat:@"%@", [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2]] substringWithRange:NSMakeRange(1, 3)] sender:self];
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

- (IBAction)pushd:(id)sender {
}

@end
