//
//  MasterViewController.m
//  MobileFastFacts
//
//  Created by Jeff Jackson on 9/24/13.
//  Copyright (c) 2013 Duquesne University. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "FastFactsDB.h"
#import "dbConstants.h"

@implementation MasterViewController
@synthesize list = _list;
@synthesize fullList = _fullList;
@synthesize ROWID;
@synthesize Result_list = _Result_list;
@synthesize database;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.list = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    database = [[FastFactsDB alloc] initWithName:@"FastFactsDB"];  // Initialize the database for the entire program.
    
    
    NSArray *result = [database getAllEntries]; // Returns Everything in database
    NSMutableArray *list2 = [NSMutableArray array];  //Dummy array for adding display elements easily.
    NSMutableArray *fullList2 = [NSMutableArray array];  //Dummy array for adding search elements easily.

    for (NSArray *row in result) {
        NSString *sname = [row objectAtIndex:SHORT_NAME];      // Get the article short name

        NSString *name = [row objectAtIndex:NAME];      // Get the article name
        NSString *number = [row objectAtIndex:NUMBER];  // Get the article number
        NSString *author = [row objectAtIndex:AUTHOR];  // Get the atricle author
        NSString *object = [NSString stringWithFormat:@"%@: %@ by %@", number, name, author];
        // #: TITLE by AUTHOR (AND AUTHOR...)
        [fullList2 addObject:object];  // Add all info for search
        [list2 addObject:sname];    // Add short name info for display
    }
    self.fullList = fullList2;
    self.list = list2;
    self.title = @"Articles";
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
        return [_list count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_Result_list count];
        
    } else {
        return _list.count;
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [_Result_list objectAtIndex:indexPath.row];
    } else {
        NSDate *list = _list[indexPath.row];
        cell.textLabel.text = [list description];
    }
    
    
    
    return cell;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        [self performSegueWithIdentifier: @"showDetail" sender: self];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        DetailViewController *destViewController = segue.destinationViewController;
        
        NSIndexPath *indexPath = nil;
        
        if ([self.searchDisplayController isActive]) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            NSString *articleName = [_Result_list objectAtIndex:indexPath.row];
            NSInteger articleNumber;
            
            if([articleName characterAtIndex:2] <= 57 && [articleName characterAtIndex:2] >= 48) {
                articleNumber = [[articleName substringToIndex:3] integerValue] - 1;
            }
            else if([articleName characterAtIndex:1] <= 57 && [articleName characterAtIndex:1] >= 48) {
                articleNumber = [[articleName substringToIndex:2] integerValue] - 1;
            }
            else {
                articleNumber = [[articleName substringToIndex:1] integerValue] - 1;
            }
            
            destViewController = [_Result_list objectAtIndex:indexPath.row];
            [[segue destinationViewController] setDetailItem:articleNumber];
            
            
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
            destViewController = [_list objectAtIndex:indexPath.row];
            [[segue destinationViewController] setDetailItem:indexPath.row];
        }
    }
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}



- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@", searchText];
    
    _Result_list = [_fullList filteredArrayUsingPredicate:resultPredicate];
}

@end