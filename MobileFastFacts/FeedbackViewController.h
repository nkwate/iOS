//
//  SettingsViewController.h
//  MobileFastFacts
//
//  Created by Mike Caterino on 3/24/2014.
//  This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.

#import <UIKit/UIKit.h>

@class  FeedbackViewController;

@interface FeedbackViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *versionNumber;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UITextView *feedbackField;

@end
