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

@synthesize displayList = _displayList;
@synthesize searchableList = _searchableList;
@synthesize ROWID;
@synthesize searchResultList = _searchResultList;
@synthesize database;
@synthesize SearchBarVisible;
@synthesize recentlyViewedTable;
@synthesize recentlyViewed = _recentlyViewed;

NSInteger MAXARTICLENUMBER = 284;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    return self;
}

- (void)viewDidLoad
{
    [self.view.superview removeFromSuperview];
    [super viewDidLoad];
    [self.view.superview removeFromSuperview];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:12.0f/255.0f green:102.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor: [UIColor whiteColor]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _recentlyViewed = [defaults arrayForKey:@"recentlyViewed"];

    // Do any additional setup after loading the view from its nib.
        
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
    
    // If it is search, return search count. Else recently viewed count.
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return [_searchResultList count];
    }
    else if (tableView == self.recentlyViewedTable){
        return [_recentlyViewed count];
    }
    else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // If it is search, return search count. Else recently viewed count.
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return [_searchResultList count];
    }
    else if (tableView == self.recentlyViewedTable){
        return [_recentlyViewed count];
    }
    else {
        return 0;
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
    }
    else if (tableView == self.recentlyViewedTable){
        NSString *article = [[_recentlyViewed objectAtIndex:indexPath.row] stringValue];
        if([article isEqualToString:@"-1"]) {
            cell.textLabel.text = @"";
        }
        else {
            NSArray *result = [database findByNumber:[[_recentlyViewed objectAtIndex:indexPath.row] integerValue]];
            
            for (NSArray *row in result) {
                article = [NSString stringWithFormat:@"%@: %@", [row objectAtIndex:NUMBER], [row objectAtIndex:SHORT_NAME]];
            }
            cell.textLabel.text = article;
        }
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
        [self.presentingViewController performSegueWithIdentifier:@"showRecent" sender:self];
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
            
            // Gets the article number that the user clicked on (characters 1-3 in the search result)
            // Subtract one for the off by one error
            NSInteger articleNumber = [[articleName substringWithRange:NSMakeRange(1, 3)] integerValue] -1;
            
            // Adds the article number to the detail item for the configureView in DetailViewController.m
            destViewController = [_searchResultList objectAtIndex:indexPath.row];
            [[segue destinationViewController] setDetailItem:articleNumber highlight:self.searchDisplayController.searchBar.text];
        }
    }
    
    else if ([segue.identifier isEqualToString:@"showRecent"]){
        NSIndexPath *indexPath = [recentlyViewedTable indexPathForSelectedRow];
        NSString *articleName = [[[recentlyViewedTable cellForRowAtIndexPath:indexPath] textLabel] text];
        
        // Gets the article number that the user clicked on (characters 0-2 in the recently viewed result)
        // Subtract one for the off by one error
        NSInteger articleNumber = [[articleName substringWithRange:NSMakeRange(0, 3)] integerValue] -1;
        
        [[segue destinationViewController] setDetailItem:articleNumber highlight:nil];
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
    [self loadView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushd:(id)sender {
}

@end
