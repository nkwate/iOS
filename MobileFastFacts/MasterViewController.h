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

@property (nonatomic, retain) NSArray *list;
@property (nonatomic, assign) NSInteger ROWID;
@property (nonatomic, retain) NSArray *Result_list;
@property (nonatomic, retain) FastFactsDB *database;
@property (strong, nonatomic) DetailViewController *detailViewController;

@end
