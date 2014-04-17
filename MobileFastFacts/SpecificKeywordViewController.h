//
//  SpecificKeywordViewController.h
//  MobileFastFacts
//
//  Created by Mike Caterino on 12/3/13.
//  This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.

#import <UIKit/UIKit.h>
#import "FastFactsDB.h"

@class DetailViewController;

@interface SpecificKeywordViewController : UITableViewController {
    NSArray *_list;
}

@property (nonatomic, retain) NSArray *articleNumberList;
@property (nonatomic, retain) NSArray *displayList;
@property (nonatomic, assign) NSInteger ROWID;
@property (nonatomic) NSString *subjectItem;
@property (nonatomic, retain) FastFactsDB *database;
@property (strong, nonatomic) DetailViewController *detailViewController;
@end
