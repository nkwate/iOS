//
//  SpecificKeywordViewController.m
//  MobileFastFacts
//
//  Created by Mike Caterino on 12/3/13.
//  This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.

#import "SpecificKeywordViewController.h"

#import "KeywordDetailViewController.h"

#import "FastFactsDB.h"
#import "dbConstants.h"

@implementation SpecificKeywordViewController

@synthesize detailItem = _detailItem;
@synthesize displayList = _displayList;
@synthesize searchableList = _searchableList;
@synthesize ROWID;
@synthesize searchResultList = _searchResultList;
@synthesize database;
@synthesize SearchBarVisible;
@synthesize articleNumberList = _articleNumberList;

- (void)setDetailItem:(NSString*)newDetailItem
{
    if (![_detailItem isEqualToString:newDetailItem]) {
        _detailItem = newDetailItem;
    }
}

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
    NSArray *result;
    
    if ([_detailItem isEqualToString:@"Core Curriculum"])
        result = [database findByKeyword:@"CORE_CURRICULUM"];
    else if ([_detailItem isEqualToString:@"Ethics Law Policy Health Systems"])
        result = [database findByKeyword:@"ETHICS_LAW_POLICY_HEALTH_SYSTEMS"];
    else if ([_detailItem isEqualToString:@"Non-Pain Symptoms Syndromes"])
        result = [database findByKeyword:@"NON_PAIN_SYMPTOMS_SYNDROMES"];
    else if ([_detailItem isEqualToString:@"Pain Evaluation"])
        result = [database findByKeyword:@"PAIN_EVALUATION"];
    else if ([_detailItem isEqualToString:@"Pain (Non-Opioids)"])
        result = [database findByKeyword:@"PAIN_NON_OPIOIDS"];
    else if ([_detailItem isEqualToString:@"Pain (Opioids)"])
        result = [database findByKeyword:@"PAIN_OPIOIDS"];
    else if ([_detailItem isEqualToString:@"Psychosocial Spiritual Experience"])
        result = [database findByKeyword:@"PSYCHOSOCIAL_SPIRITUAL_EXPERIENCE"];
    else if ([_detailItem isEqualToString:@"Other Neurological Disorders"])
        result = [database findByKeyword:@"OTHER_NEUROLOGICAL_DISORDERS"];
    else
        result = [database findByKeyword:_detailItem];
    
    NSMutableArray *displayList2 = [NSMutableArray array];  //Dummy array for adding display elements easily.
    NSMutableArray *searchableList2 = [NSMutableArray array];  //Dummy array for adding search elements easily.
    NSMutableArray *articleNumberList2 = [NSMutableArray array];
    
    for (NSArray *row in result) {
        [displayList2 addObject:[row objectAtIndex:NAME]];
        [articleNumberList2 addObject:[row objectAtIndex:NUMBER]];
        
        NSString *name = [row objectAtIndex:NAME];      // Get the article name
        NSString *number = [row objectAtIndex:NUMBER];  // Get the article number
        NSString *author = [row objectAtIndex:AUTHOR];  // Get the atricle author
        NSString *object = [NSString stringWithFormat:@"%@: %@ by %@", number, name, author];
        [searchableList2 addObject:object];  // Add all info for search
    }
    
    // Hide the search bar until user scrolls up
    [self HideSearchBar:YES];
    
    self.searchableList = displayList2;
    self.displayList = displayList2;
    self.articleNumberList = articleNumberList2;
    self.title = _detailItem;
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
    NSIndexPath *indexPath = nil;
    KeywordDetailViewController *destViewController = segue.destinationViewController;
    destViewController.title = @"";
    
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        // If it is a search...
        if ([self.searchDisplayController isActive]) {
            //Do Search
        }
    } else {
        indexPath = [self.tableView indexPathForSelectedRow];
        destViewController = [_displayList objectAtIndex:indexPath.row];
        [[segue destinationViewController] setDetailItem:[_articleNumberList objectAtIndex:indexPath.row]];
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