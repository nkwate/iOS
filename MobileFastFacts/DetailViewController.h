//
//  DetailViewController.h
//  MobileFastFacts
//
//  Created by FA13-COSC 445W-01 on 9/24/13 with further revisions from Mike Caterino.
//  This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, UIWebViewDelegate>

@property (nonatomic) NSInteger detailItem;
@property (nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic) UIBarButtonItem *leftButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *previousArticleButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextArticleButton;

+ (NSString *)formatFileName:(NSInteger)n;

- (void)setDetailItem:(NSInteger)newDetailItem;

@end
