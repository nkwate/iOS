//
//  DetailViewController.h
//  MobileFastFacts
//
//  Created by Jeff Jackson on 9/24/13.
//  Copyright (c) 2013 Duquesne University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeywordDetailViewController : UIViewController <UISplitViewControllerDelegate, UIWebViewDelegate>

@property (nonatomic) NSInteger *detailItem;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

+ (NSString *)formatFileName:(NSInteger)n;

@end