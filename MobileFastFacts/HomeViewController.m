//
//  HomeViewController.m
//  MobileFastFacts
//
//  Created by FA13-COSC 445W-01 on 11/3/13 with further revisions from Mike Caterino.
//  This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.

#import "HomeViewController.h"
#import "DFFRecentlyViewed.h"

#import "DetailViewController.h"
#import "FastFactsDB.h"
#import "dbConstants.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize VersionNumber = _VersionNumber;
@synthesize recentlyViewed = _recentlyViewed;

@synthesize displayList = _displayList;
@synthesize searchableList = _searchableList;
@synthesize ROWID;
@synthesize searchResultList = _searchResultList;
@synthesize database;
@synthesize SearchBarVisible;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    // Do any additional setup after loading the view from its nib.
    
    // Add the version number to the Home View screen.
    _VersionNumber.text = [@"Version " stringByAppendingString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
    DFFRecentlyViewed *rvqueue = [[DFFRecentlyViewed alloc] init];
    _recentlyViewed = [rvqueue getQueue];
    
    // Prepare global search
    
    database = [[FastFactsDB alloc] initWithName:@"FastFactsDB"];  // Initialize the database for the entire program.
    
    NSArray *result = [database getAllEntries]; // Returns Everything in database
    NSMutableArray *searchableList2 = [NSMutableArray array];  //Dummy array for adding search elements easily.
    
    for (NSArray *row in result) {
        [searchableList2 addObject:[row objectAtIndex:ARTICLE_BODY]];
    }
    _searchableList = searchableList2;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
                   numberOfRowsInSection:(NSInteger)section {
    return [_searchableList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchResultList.count;
}

/* FOR Recently Viewed
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 static NSString *simpleTableIdentifier = @"Cell";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
 }
 
 else {
 NSDate *list = _recentlyViewed[indexPath.row];
 cell.textLabel.text = [list description];
 }
 
 return cell;
 return cell;
 }
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [_searchResultList objectAtIndex:indexPath.row];
    }
    
    return cell;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

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
            
            // Gets the article number that the user clicked on (characters 5-7 in the search result)
            // Subtract one for the off by one error
            articleNumber = [[articleName substringWithRange:NSMakeRange(3, 3)] integerValue] -1;
            
            // Adds the article number to the detail item for the configureView in DetailViewController.m
            destViewController = [_searchResultList objectAtIndex:indexPath.row];
            [[segue destinationViewController] setDetailItem:articleNumber];
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
    //_searchResultList = [database findByArticleBody:searchText];

 NSPredicate *resultPredicate = [NSPredicate
 predicateWithFormat:@"SELF contains[cd] %@", searchText];
 
 _searchResultList = [_searchableList filteredArrayUsingPredicate:resultPredicate];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {

}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushd:(id)sender {
}

@end
