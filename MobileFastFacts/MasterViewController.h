//
//  MasterViewController.h
//  MobileFastFacts
//
//  Created by Jeff Jackson on 9/24/13.
//  Copyright (c) 2013 Duquesne University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FastFactsDB.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController {
    NSArray *_list;
}


@property (nonatomic, retain) NSArray *displayList;
@property (nonatomic, retain) NSArray *searchableList;
@property (nonatomic, assign) NSInteger ROWID;
@property (nonatomic, retain) NSArray *searchResultList;
@property (nonatomic, retain) FastFactsDB *database;
@property (strong, nonatomic) DetailViewController *detailViewController;
@property IBOutlet UISearchBar *SearchBarVisible;
-(IBAction)goToSearch:(id)sender;
@end
