//
//  KeywordViewController.h
//  MobileFastFacts
//
//  Created by Mike Caterino on 12/3/13.
//  Copyright (c) 2013 Duquesne University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FastFactsDB.h"

@class SpecificKeywordViewController;

@interface KeywordViewController : UITableViewController {
    NSArray *_list;
}


@property (nonatomic, retain) NSArray *displayList;
@property (nonatomic, retain) NSArray *searchableList;
@property (nonatomic, assign) NSInteger ROWID;
@property (nonatomic, assign) NSString *keyword;
@property (nonatomic, retain) NSArray *searchResultList;
@property (nonatomic, retain) FastFactsDB *database;
@property (strong, nonatomic) SpecificKeywordViewController *detailViewController;
@property IBOutlet UISearchBar *SearchBarVisible;
-(IBAction)goToSearch:(id)sender;
@end
