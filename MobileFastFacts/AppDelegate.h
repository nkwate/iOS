//
//  AppDelegate.h
//  MobileFastFacts
//
//  Created by FA13-COSC 445W-01 on 9/24/13 with further revisions from Mike Caterino.
//  This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.


#import <UIKit/UIKit.h>
#import "FastFactsDB.h"
#import "dbConstants.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property () BOOL restrictRotation;

@end
