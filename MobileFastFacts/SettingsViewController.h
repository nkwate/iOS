//
//  SettingsViewController.h
//  MobileFastFacts
//
//  Created by Mike Caterino on 3/24/2014.
//  This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.

#import <UIKit/UIKit.h>

@class  SettingsViewController;

@interface SettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *versionNumber;
@property (retain) IBOutlet UIStepper *slider;
@property (weak, nonatomic) IBOutlet UILabel *sampleText;
@property (weak, nonatomic) IBOutlet UIButton *whiteOnBlack;
@property (weak, nonatomic) IBOutlet UIButton *blackOnWhite;
@property (weak, nonatomic) IBOutlet UIButton *paper;
@property (strong, nonatomic) NSUserDefaults *defaults;
@property (weak, nonatomic) IBOutlet UISwitch *highlightSwitch;
@property (weak, nonatomic) IBOutlet UILabel *highlightEnabledText;

+ (NSInteger) getFontSizeValue;
+ (NSInteger) getStyleSheet;
+ (BOOL) getCanBeHighlighted;
@end
