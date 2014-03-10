//
//  CotMViewController.h
//  MobileFastFacts
//
//  Created by Jeff Jackson on 9/24/13.
//  Copyright (c) 2013 Duquesne University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CotMViewController : UIViewController <UISplitViewControllerDelegate, UIWebViewDelegate>

@property (nonatomic) NSInteger detailItem;
@property (nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic) UIBarButtonItem *leftButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *previousButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic) NSInteger MAXCOTMNUM;

@end
