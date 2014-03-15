//
//  SpecificKeywordViewController.h
//  MobileFastFacts
//
//  Created by Mike Caterino on 12/3/13.
//  This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.

#import <UIKit/UIKit.h>
#import "FastFactsDB.h"

@class KeywordDetailViewController;

@interface SpecificKeywordViewController : UITableViewController {
    NSArray *_list;
}

@property (nonatomic, retain) NSArray *articleNumberList;
@property (nonatomic, retain) NSArray *displayList;
@property (nonatomic, retain) NSArray *searchableList;
@property (nonatomic, assign) NSInteger ROWID;
@property (nonatomic) NSString *detailItem;
@property (nonatomic, retain) NSArray *searchResultList;
@property (nonatomic, retain) FastFactsDB *database;
@property (strong, nonatomic) KeywordDetailViewController *detailViewController;
@property IBOutlet UISearchBar *SearchBarVisible;
-(IBAction)goToSearch:(id)sender;
@end
