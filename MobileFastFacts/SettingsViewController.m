//
//  SettingsViewController.m
//  MobileFastFacts
//
//  Created by Mike Caterino on 3/24/2014.
//  This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.

#import "SettingsViewController.h"
#import "TestFlight.h"

@interface SettingsViewController ()

@end

//static NSInteger fontSizeValue = 15;
static NSInteger fontSizeValue = 5;
static NSInteger cssValue = 1;
//static NSInteger FONTSIZEDEFAULT = 15;
static NSInteger FONTSIZEDEFAULT = 5;



@implementation SettingsViewController

@synthesize versionNumber = _versionNumber;
@synthesize slider = _slider;
@synthesize sampleText = _sampleText;
@synthesize whiteOnBlack;
@synthesize blackOnWhite;
@synthesize paper;
@synthesize defaults;

+ (NSInteger) getFontSizeValue {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults floatForKey:@"fontSizeValue"] == 0) {
        if([[UIScreen mainScreen] bounds].size.height == 568) {
            FONTSIZEDEFAULT = 6;
            fontSizeValue = 6;
        }
        else if([[UIScreen mainScreen] bounds].size.height > 568) {
            FONTSIZEDEFAULT = 7;
            fontSizeValue = 7;
        }
        
        [defaults setFloat: fontSizeValue forKey:@"fontSizeValue"];
        [defaults synchronize];
    }
    // Else load the data.
    else
        fontSizeValue = [defaults floatForKey:@"fontSizeValue"];
    return fontSizeValue;
}

+ (NSInteger) getStyleSheet {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults integerForKey:@"cssValue"] == 0) {
        [defaults setInteger:cssValue forKey:@"cssValue"];
        [defaults synchronize];
    }
    // Else load the data.
    else
        cssValue = [defaults integerForKey:@"cssValue"];
    return cssValue;
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
    defaults = [NSUserDefaults standardUserDefaults];
    
    if([[UIScreen mainScreen] bounds].size.height == 568) {
        FONTSIZEDEFAULT = 6;
        fontSizeValue = 6;
    }
    
    else if([[UIScreen mainScreen] bounds].size.height > 568) {
        FONTSIZEDEFAULT = 7;
        fontSizeValue = 7;
    }

    
    // If there is no data stored yet (first time installing the app)
    if([defaults floatForKey:@"fontSizeValue"] == 0) {
        [defaults setFloat:fontSizeValue forKey:@"fontSizeValue"];
        [defaults synchronize];
    }
    // Else load the data.
    else
        fontSizeValue = [defaults floatForKey:@"fontSizeValue"];
    
    if([defaults integerForKey:@"cssValue"] == 0) {
        [defaults setInteger:cssValue forKey:@"cssValue"];
        [defaults synchronize];
    }
    // Else load the data.
    else
        cssValue = [defaults integerForKey:@"cssValue"];
    
    if(cssValue == 1) {
        whiteOnBlack.selected = false;
        blackOnWhite.selected = true;
        paper.selected = false;
    }
    else if(cssValue == 2) {
        whiteOnBlack.selected = true;
        blackOnWhite.selected = false;
        paper.selected = false;
    }
    else if(cssValue == 3) {
        whiteOnBlack.selected = false;
        blackOnWhite.selected = false;
        paper.selected = true;
    }
    else {
        NSLog(@"There was an error getting the css value in method viewDidLoad in SettingsViewController.m. cssValue=%ld",(long)cssValue);
    }
    
    self.navigationItem.hidesBackButton = YES;
    
    // Add the version number to the Settings View screen.
    _versionNumber.text = [@"Version " stringByAppendingString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
    _slider.value = fontSizeValue;
    
    // Manipulation of slider values so that it will be a percentage.
    NSInteger displayValue = fontSizeValue*100/FONTSIZEDEFAULT;
    _sampleText.text = [NSString stringWithFormat:@"The current font size is set to %ld%%.", (long)displayValue];
    [_sampleText setFont:[UIFont systemFontOfSize:(int) _slider.value*3]];
    
    [super viewDidLoad];
}

- (IBAction)sliderValueChanged:(id)sender {
    [TestFlight passCheckpoint:@"Changed Font Size"];

    fontSizeValue = _slider.value;
    
    NSInteger displayValue = fontSizeValue*100/FONTSIZEDEFAULT;
    _sampleText.text = [NSString stringWithFormat:@"The current font size is set to %ld%%.", (long)displayValue];
    [_sampleText setFont:[UIFont systemFontOfSize:(int) _slider.value*3]];
    
    // Store the slider value in the key "fontSizeValue" on the user's device.
    [defaults setFloat:fontSizeValue forKey:@"fontSizeValue"];
    [defaults synchronize];
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

- (IBAction)blackOnWhiteClicked:(id)sender {
    [TestFlight passCheckpoint:@"Changed CSS BW"];

    cssValue = 1;
    [defaults setInteger:cssValue forKey:@"cssValue"];
    [defaults synchronize];
    
    whiteOnBlack.selected = false;
    blackOnWhite.selected = true;
    paper.selected = false;
}

- (IBAction)whiteOnBlackClicked:(id)sender {
    [TestFlight passCheckpoint:@"Changed CSS WB"];

    cssValue = 2;
    [defaults setInteger:cssValue forKey:@"cssValue"];
    [defaults synchronize];
    
    whiteOnBlack.selected = true;
    blackOnWhite.selected = false;
    paper.selected = false;
}

- (IBAction)paperClicked:(id)sender {
    [TestFlight passCheckpoint:@"Changed CSS Peach"];

    cssValue = 3;
    [defaults setInteger:cssValue forKey:@"cssValue"];
    [defaults synchronize];
    
    whiteOnBlack.selected = false;
    blackOnWhite.selected = false;
    paper.selected = true;
}

- (IBAction)clearFirstRunToken:(id)sender {
    [TestFlight passCheckpoint:@"Cleared First Run Token"];

    [defaults setInteger:2 forKey:@"firstRun"];
    [defaults synchronize];
}


@end
