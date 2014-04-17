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
@synthesize ROWID;
@synthesize database;

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
    self.navigationController.navigationBarHidden = NO;
    
	// Do any additional setup after loading the view, typically from a nib.
    database = [[FastFactsDB alloc] initWithName:@"FastFactsDB"];  // Initialize the database for the entire program.
    
    
    NSArray *result = [database getAllEntries]; // Returns Everything in database
    NSMutableArray *displayList2 = [NSMutableArray array];  //Dummy array for adding display elements easily.
    
    for (NSArray *row in result) {
        NSString *sname = [row objectAtIndex:SHORT_NAME];      // Get the article short name
        NSString *number = [row objectAtIndex:NUMBER];  // Get the article number
        NSString *object2 = [NSString stringWithFormat:@"%@: %@", number, sname];
        [displayList2 addObject:object2];    // Add short name info for display
    }
    
    self.displayList = displayList2;
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
    return [_displayList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _displayList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSDate *list = _displayList[indexPath.row];
    cell.textLabel.text = [list description];
    
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
        indexPath = [self.tableView indexPathForSelectedRow];
        destViewController = [_displayList objectAtIndex:indexPath.row];
        [[segue destinationViewController] setDetailItem:indexPath.row];
    }
}

@end