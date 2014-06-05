//
//  HomeViewController.m
//  MobileFastFacts
//
//  Created by FA13-COSC 445W-01 on 11/3/13 with further revisions from Mike Caterino.
//  This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.

#import "HomeViewController.h"
#import "DetailViewController.h"
#import "FastFactsDB.h"
#import "dbConstants.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
//@synthesize recentlyViewed = _recentlyViewed;

@synthesize displayList = _displayList;
@synthesize searchableList = _searchableList;
@synthesize ROWID;
@synthesize searchResultList = _searchResultList;
@synthesize database;
@synthesize SearchBarVisible;

NSInteger MAXARTICLENUMBER = 272;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    //DFFRecentlyViewed *rvqueue = [[DFFRecentlyViewed alloc] init];
    //_recentlyViewed = [rvqueue getQueue];
    
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
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
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
    else {
        cell.textLabel.text = @"Test";
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
    else {
        [self performSegueWithIdentifier: @"showDetail" sender:self];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailViewController *destViewController = segue.destinationViewController;
    destViewController.title = @"";
    
    if ([segue.identifier isEqualToString:@"showDetail"]) {
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
            [[segue destinationViewController] setDetailItem:articleNumber highlight:self.searchDisplayController.searchBar.text];
        }
    }
    else if([segue.identifier isEqualToString:@"articleOfTheDay"]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *date = [defaults stringForKey:@"articleOfTheDay-Date"];
        NSDateFormatter *todaysDate = [[NSDateFormatter alloc]init];
        [todaysDate setDateFormat:@"dd"];
        NSString *dateToday =[todaysDate stringFromDate:[[NSDate alloc] init]];
        
        NSInteger articleToBeShown = [defaults integerForKey:@"articleOfTheDay"];;
        
        NSArray *articlesShown = [defaults arrayForKey:@"articleOfTheDay-Shown"];
        
        if(![date isEqualToString:dateToday]) {
            date = dateToday;
            [defaults setObject:dateToday forKey:@"articleOfTheDay-Date"];
            [defaults synchronize];
            
            bool keepGoing = true;
            articleToBeShown = (arc4random() % MAXARTICLENUMBER) + 0;
                        
            if([articlesShown count] != 0 && [articlesShown count] != MAXARTICLENUMBER) {
                do {
                    keepGoing = false;
                    for(int i = 0; i < [articlesShown count]; i++){
                        if([[NSString stringWithFormat:@"%ld", (long)articleToBeShown] isEqualToString:articlesShown[i]]) {
                            articleToBeShown++;
                            i = [articlesShown count];
                            keepGoing = true;
                        }
                    }
                } while (keepGoing);
                
                NSMutableArray *newArray = [articlesShown mutableCopy];
                [newArray addObject:[NSString stringWithFormat:@"%ld", (long)articleToBeShown]];
                articlesShown = newArray;
                [defaults setObject:articlesShown forKey:@"articleOfTheDay-Shown"];
                [defaults setInteger:articleToBeShown forKey:@"articleOfTheDay"];
                [defaults synchronize];
            }
            
            else {
                [defaults setObject:[NSArray arrayWithObject:[NSString stringWithFormat:@"%ld", (long)articleToBeShown]] forKey:@"articleOfTheDay-Shown"];
                [defaults setInteger:articleToBeShown forKey:@"articleOfTheDay"];
                [defaults synchronize];
            }
        }
        
        [[segue destinationViewController] setDetailItem:articleToBeShown highlight:nil];
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
