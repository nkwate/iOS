//
//  DetailViewController.h
//  MobileFastFacts
//
//  Created by Jeff Jackson on 9/24/13.
//  Copyright (c) 2013 Duquesne University. All rights reserved.
//

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
