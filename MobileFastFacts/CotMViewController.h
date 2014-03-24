//
//  CotMViewController.h
//  MobileFastFacts
//
//  Created by Mike Caterino in February 2014.
//  This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.

#import <UIKit/UIKit.h>

@interface CotMViewController : UIViewController <UISplitViewControllerDelegate, UIWebViewDelegate>

@property (nonatomic) NSInteger detailItem;
@property (nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic) UIBarButtonItem *leftButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *previousButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic) NSInteger MAXCOTMNUM;
@property (nonatomic) BOOL showToolbar;
@property (weak, nonatomic) IBOutlet UIToolbar *navBar;

@end
