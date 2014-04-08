//
//  MasterViewController.m
//  MobileFastFacts
//
//  Created by FA13-COSC 445W-01 on 9/24/13 with further revisions from Mike Caterino.
//  This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "FastFactsDB.h"
#import "dbConstants.h"

@implementation MasterViewController
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
    
    
    NSArray *result = [database getAllEntries]; // Returns Everything in database
    NSMutableArray *displayList2 = [NSMutableArray array];  //Dummy array for adding display elements easily.
    NSMutableArray *searchableList2 = [NSMutableArray array];  //Dummy array for adding search elements easily.

    for (NSArray *row in result) {
        NSString *sname = [row objectAtIndex:SHORT_NAME];      // Get the article short name
        NSString *name = [row objectAtIndex:NAME];      // Get the article name
        NSString *number = [row objectAtIndex:NUMBER];  // Get the article number
        NSString *author = [row objectAtIndex:AUTHOR];  // Get the atricle author
        NSString *object = [NSString stringWithFormat:@"%@: %@ by %@", number, name, author];
        [searchableList2 addObject:object];  // Add all info for search
        NSString *object2 = [NSString stringWithFormat:@"%@", sname];
        [displayList2 addObject:object2];    // Add short name info for display

        NSLog(@"%@", object2);
    }
    
    // Hide the search bar until user scrolls up
    [self HideSearchBar:YES];
    
    self.searchableList = searchableList2;
    self.displayList = displayList2;
    self.title = @"Articles";
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
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        DetailViewController *destViewController = segue.destinationViewController;
        destViewController.title = @"";
        
        NSIndexPath *indexPath = nil;
        
        // If it is a search...
        if ([self.searchDisplayController isActive]) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            NSString *articleName = [_searchResultList objectAtIndex:indexPath.row];
            NSInteger articleNumber;
            
            // Gets the article number that the user clicked on (first 1-3 characters in the search result)
            if([articleName characterAtIndex:2] <= 57 && [articleName characterAtIndex:2] >= 48) {
                articleNumber = [[articleName substringToIndex:3] integerValue] - 1;
            }
            else if([articleName characterAtIndex:1] <= 57 && [articleName characterAtIndex:1] >= 48) {
                articleNumber = [[articleName substringToIndex:2] integerValue] - 1;
            }
            else {
                articleNumber = [[articleName substringToIndex:1] integerValue] - 1;
            }
            
            // Adds the article number to the detail item for the configureView in DetailViewController.m
            destViewController = [_searchResultList objectAtIndex:indexPath.row];
            [[segue destinationViewController] setDetailItem:articleNumber];
            
        // Else it is not a search, so display the regular list and set the article number as the detail item.
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
            destViewController = [_displayList objectAtIndex:indexPath.row];
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


// Searches the users query (searchText) in searchableList (full list of Article Number, Name, and Author)
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