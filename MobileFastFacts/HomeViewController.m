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
#import "TestFlight.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize VersionNumber = _VersionNumber;
@synthesize recentlyViewed = _recentlyViewed;

@synthesize displayList = _displayList;
@synthesize searchableList = _searchableList;
@synthesize ROWID;
@synthesize searchResultList = _searchResultList;
@synthesize srl;
@synthesize searchDisplayList = _searchDisplayList;
@synthesize database;
@synthesize SearchBarVisible;
/*
 - (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
 {
 NSLog(@"HERE yo yo");
 if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
 NSLog(@"HERE yo yo 2");{
 
 [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
 }
 else {
 
 }
 }
 */

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.navigationItem.hidesBackButton = YES;
    
    // Do any additional setup after loading the view from its nib.
    
    // Add the version number to the Home View screen.
    _VersionNumber.text = [@"Version " stringByAppendingString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
    //DFFRecentlyViewed *rvqueue = [[DFFRecentlyViewed alloc] init];
    //_recentlyViewed = [rvqueue getQueue];
    
    // Prepare global search
    
    database = [[FastFactsDB alloc] initWithName:@"FastFactsDB"];  // Initialize the database for the entire program.
    
    NSArray *result = [database getAllEntries]; // Returns Everything in database
    NSMutableArray *searchableList2 = [NSMutableArray array];  //Dummy array for adding search elements easily.
    NSMutableArray *searchDisplayList2 = [NSMutableArray array];
    
    for (NSArray *row in result) {
        [searchableList2 addObject:[row objectAtIndex:ARTICLE_BODY]];
        [srl addObject:[row objectAtIndex:ARTICLE_BODY]];
        
        NSString *sname = [row objectAtIndex:SHORT_NAME];
        NSString *number = [row objectAtIndex:NUMBER];
        NSString *object = [NSString stringWithFormat:@"%@: %@", number, sname];
        [searchDisplayList2 addObject:object];
    }
    _searchableList = searchableList2;
    _searchDisplayList = searchDisplayList2;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
                   numberOfRowsInSection:(NSInteger)section {
    return [_searchResultList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [TestFlight passCheckpoint:@"Global Search Used"];

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

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchText];
    _searchResultList = [[_searchableList filteredArrayUsingPredicate:resultPredicate] mutableCopy];
    if([_searchResultList count] != 0) {
        NSMutableArray *countInResult = [NSMutableArray array];
        for(int i = 0; i < [_searchResultList count]; i++){
            NSError *error = NULL;
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:searchText options:NSRegularExpressionCaseInsensitive error:&error];
            NSUInteger numberOfMatches = [regex numberOfMatchesInString:_searchResultList[i] options:0 range:NSMakeRange(0, [_searchResultList[i] length])];
            [countInResult addObject:[NSNumber numberWithInteger:numberOfMatches]];
        }
        countInResult = [self quicksort:countInResult comparator:^(id x, id y) { return [x compare:y];}];
    }
}

- (void) quicksortInPlace:(NSMutableArray *)array first:(NSInteger) first last:(NSInteger) last comparator:(NSComparator) comparator {
    if (first >= last) return;
    id pivot = array[(first + last) / 2];
    NSInteger left = first;
    NSInteger right = last;
    while (left <= right) {
        while (comparator(array[left], pivot) == NSOrderedDescending) {
            left++;
        }
        while (comparator(array[right], pivot) == NSOrderedAscending) {
            right--;
        }
        if (left <= right) {
            [array exchangeObjectAtIndex:left withObjectAtIndex:right];
            [_searchResultList exchangeObjectAtIndex:left++ withObjectAtIndex:right--];
        }
    }
    [self quicksortInPlace:array first:first last:right comparator:comparator];
    [self quicksortInPlace:array first:left last:last comparator:comparator];
}

- (NSMutableArray*) quicksort:(NSArray *)unsorted comparator:(NSComparator)comparator {
    NSMutableArray *a = [NSMutableArray arrayWithArray:unsorted];
    [self quicksortInPlace:a first:0 last:[a count]-1 comparator:comparator];
    return a;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushd:(id)sender {
}

@end
