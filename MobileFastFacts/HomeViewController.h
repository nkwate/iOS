//
//  HomeViewController.h
//  MobileFastFacts
//
//  Created by FA13-COSC 445W-01 on 11/3/13 with further revisions from Mike Caterino.
//  This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.

#import <UIKit/UIKit.h>
#import "FastFactsDB.h"

@class DetailViewController;

@interface HomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSArray *_list;
}

@property (weak, nonatomic) IBOutlet UIButton *Articles;
- (IBAction)pushd:(id)sender;

//@property (nonatomic, retain) NSArray *recentlyViewed;

@property (nonatomic, retain) NSArray *displayList;
@property (nonatomic, retain) NSArray *searchableList;
@property (nonatomic, assign) NSInteger ROWID;
@property (nonatomic, retain) NSMutableArray *searchResultList;
@property (nonatomic, retain) FastFactsDB *database;
@property (strong, nonatomic) DetailViewController *detailViewController;
@property IBOutlet UISearchBar *SearchBarVisible;

@end
