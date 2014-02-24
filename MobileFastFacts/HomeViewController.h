//
//  HomeViewController.h
//  MobileFastFacts
//
//  Created by JMAMacUser on 11/3/13.
//  Copyright (c) 2013 Duquesne University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FastFactsDB.h"

@class  DetailViewController;

@interface HomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *Articles;
- (IBAction)pushd:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *VersionNumber;

@property (nonatomic, retain) NSArray *recentlyViewed;

@end
