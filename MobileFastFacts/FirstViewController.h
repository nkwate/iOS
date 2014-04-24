//
//  HomeViewController.h
//  MobileFastFacts
//
//  Created by Mike Caterino on 4/16/2014.
//  This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.

#import <UIKit/UIKit.h>
#import "FastFactsDB.h"

@class FirstViewController;

@interface FirstViewController : UIViewController 

@property (weak, nonatomic) IBOutlet UILabel *VersionNumber;
@property (strong, nonatomic) IBOutlet UIImageView *display;
@property (weak, nonatomic) IBOutlet UIPageControl *pageController;

@property (strong, nonatomic) UIImage *image1;
@property (strong, nonatomic) UIImage *image2;
@property (strong, nonatomic) UIImage *image3;
@property (strong, nonatomic) UIImage *image4;
@property (strong, nonatomic) UIImage *image5;
@property (strong, nonatomic) UIImage *image6;

@property (strong, nonatomic) NSUserDefaults *defaults;



@end