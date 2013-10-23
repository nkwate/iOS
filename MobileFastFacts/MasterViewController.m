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
@synthesize ROWID;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.list = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    FastFactsDB *database = [[FastFactsDB alloc] initWithName:@"FastFactsDB"];
    NSArray *result = [database getAllEntries]; // Returns Everything in database
    NSMutableArray *list2 = [NSMutableArray array];  // Grabs and formats the data from the database
    for (NSArray *row in result) {
        NSString *name = [row objectAtIndex:NAME];      // Get the article name
        NSString *number = [row objectAtIndex:NUMBER];  // Get the article number
        NSString *author = [row objectAtIndex:AUTHOR];  // Get the atricle author
        NSString *object = [NSString stringWithFormat:@"%@: %@ by %@", number, name, author];
        // #: TITLE by AUTHOR (AND AUTHOR...)
        [list2 addObject:object];
    }
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
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *list = _list[indexPath.row];
    cell.textLabel.text = [list description];
    
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

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSDate *list = _list[indexPath.row];
        self.detailViewController.detailItem = list;
    }
    // UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    ROWID = indexPath.row;
    
}
*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        // NSDate *list = _list[indexPath.row];
        [[segue destinationViewController] setDetailItem:indexPath.row];
    }
}

@end
