//
//  KeywordViewController.m
//  MobileFastFacts
//
//  Created by Mike Caterino on 12/3/13.
//  This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.

#import "KeywordViewController.h"

#import "SpecificKeywordViewController.h"
#import "FastFactsDB.h"
#import "dbConstants.h"

@implementation KeywordViewController
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
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    database = [[FastFactsDB alloc] initWithName:@"FastFactsDB"];  // Initialize the database for the entire program.
    
    
    NSArray *result = @[@"Pain (all)", @"Opioids Basic", @"Opioids Advanced", @"Non-Pain Symptoms", @"Misc. Syndromes", @"Communication - Basic", @"Communication - Advanced", @"Nutrition/Hydration", @"Ethics", @"Hospice", @"Prognosis", @"Misc. Interventions", @"Culture/Spiritual/Grief", @"Clinician Self Care", @"Palliative Care Practice", @"Special Conditions"];
    
    self.displayList = result;
    self.title = @"Subjects";
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
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SpecificKeywordViewController *destViewController = segue.destinationViewController;
    
    NSIndexPath *indexPath = nil;
    
    indexPath = [self.tableView indexPathForSelectedRow];
    destViewController = [_displayList objectAtIndex:indexPath.row];
    [[segue destinationViewController] setSubjectItem:[_displayList objectAtIndex:indexPath.row]];
}

@end