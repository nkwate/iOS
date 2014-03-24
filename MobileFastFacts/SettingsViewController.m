//
//  SettingsViewController.m
//  MobileFastFacts
//
//  Created by Mike Caterino on 3/24/2014.
//  This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

static NSInteger fontSizeValue = 15;


@implementation SettingsViewController

@synthesize versionNumber = _versionNumber;
@synthesize slider = _slider;
@synthesize sampleText = _sampleText;

+ (NSInteger) getFontSizeValue {
    return fontSizeValue;
}

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
    // Load the user defaults (to store/retrieve persistant data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // If there is no data stored yet (first time installing the app)
    if([defaults integerForKey:@"fontSizeValue"] == 0) {
        [defaults setInteger:fontSizeValue forKey:@"fontSizeValue"];
        [defaults synchronize];
    }
    // Else load the data.
    else
        fontSizeValue = [defaults integerForKey:@"fontSizeValue"];
    
    self.navigationItem.hidesBackButton = YES;
    
    // Add the version number to the Settings View screen.
    _versionNumber.text = [@"Version " stringByAppendingString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
    _slider.value = fontSizeValue;

    // Manipulation of slider values so that it will be a percentage.
    NSInteger displayValue = fontSizeValue*100/15;
    _sampleText.text = [NSString stringWithFormat:@"The current font size is set to %d%%.", displayValue];
    [_sampleText setFont:[UIFont systemFontOfSize:(int) _slider.value]];
    
    [super viewDidLoad];
}

- (IBAction)sliderValueChanged:(id)sender {
    fontSizeValue = _slider.value;

    NSInteger displayValue = fontSizeValue*100/15;
    _sampleText.text = [NSString stringWithFormat:@"The current font size is set to %d%%.", displayValue];
    [_sampleText setFont:[UIFont systemFontOfSize:(int) _slider.value]];
    
    // Store the slider value in the key "fontSizeValue" on the user's device.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:fontSizeValue forKey:@"fontSizeValue"];
    [defaults synchronize];
}

- (void)viewWillAppear:(BOOL)animated
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushd:(id)sender {
}

@end
