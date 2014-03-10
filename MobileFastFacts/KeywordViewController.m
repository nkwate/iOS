//
//  KeywordViewController.m
//  MobileFastFacts
//
//  Created by Mike Caterino on 12/3/13.
//  Copyright (c) 2013 Duquesne University. All rights reserved.
//

#import "KeywordViewController.h"

#import "SpecificKeywordViewController.h"
#import "FastFactsDB.h"
#import "dbConstants.h"

@implementation KeywordViewController
@synthesize displayList = _displayList;
@synthesize searchableList = _searchableList;
@synthesize ROWID;
@synthesize searchResultList = _searchResultList;
@synthesize database;
@synthesize SearchBarVisible;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.displayList = nil;
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
    
    
    NSArray *result = @[@"Communication", @"Core Curriculum", @"Ethics Law Policy Health Systems", @"Geriatrics", @"Non-Pain Symptoms Syndromes", @"Pain Evaluation", @"Pain (Non-Opioids)", @"Pain (Opioids)", @"Pediatrics", @"Prognosis", @"Psychosocial Spiritual Experience", @"ICU", @"Cancer", @"Other Neurological Disorders"];
    
    // Hide the search bar until user scrolls up
    [self HideSearchBar:YES];
    
    self.searchableList = result;
    self.displayList = result;
    self.title = @"Keywords";
}

- (void)HideSearchBar :(BOOL)animated
{
    
    // scroll the search bar off-screen
    CGRect newBounds = self.tableView.bounds;
    newBounds.origin.y = newBounds.origin.y + self.SearchBarVisible.bounds.size.height;
    self.tableView.bounds = newBounds;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
                   numberOfRowsInSection:(NSInteger)section {
    return [_displayList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_searchResultList count];
        
    } else {
        return _displayList.count;
        
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
        cell.textLabel.text = [_searchResultList objectAtIndex:indexPath.row];
    } else {
        NSDate *list = _displayList[indexPath.row];
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
    SpecificKeywordViewController *destViewController = segue.destinationViewController;
    
    NSIndexPath *indexPath = nil;
    
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        // If it is a search...
        if ([self.searchDisplayController isActive]) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            
            destViewController = [_searchResultList objectAtIndex:indexPath.row];
            [[segue destinationViewController] setDetailItem:[_displayList objectAtIndex:indexPath.row]];
            
            // Else it is not a search, so display the regular list and set the keyword reference number as the detail item.
        }
    }
    else {
        indexPath = [self.tableView indexPathForSelectedRow];
        destViewController = [_displayList objectAtIndex:indexPath.row];
        [[segue destinationViewController] setDetailItem:[_displayList objectAtIndex:indexPath.row]];
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


// Searches the users query (searchText) in searchableList (full list of keywords)
// Stores the search result in searchResultList
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF contains[cd] %@", searchText];
    
    _searchResultList = [_searchableList filteredArrayUsingPredicate:resultPredicate];
}

// this will help the search icon to bring the searc bar when cliked
-(IBAction)goToSearch:(id)sender
{
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    
    [SearchBarVisible becomeFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [self HideSearchBar:YES];
    
}

@end