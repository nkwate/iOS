//
//  SpecificKeywordViewController.m
//  MobileFastFacts
//
//  Created by Mike Caterino on 12/3/13.
//  This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.

#import "SpecificKeywordViewController.h"

#import "DetailViewController.h"


#import "FastFactsDB.h"
#import "dbConstants.h"

@implementation SpecificKeywordViewController

@synthesize subjectItem = _subjectItem;
@synthesize displayList = _displayList;
@synthesize ROWID;
@synthesize database;
@synthesize articleNumberList = _articleNumberList;

- (void)setSubjectItem:(NSString*)newSubjectItem
{
    if (![_subjectItem isEqualToString:newSubjectItem]) {
        _subjectItem = newSubjectItem;
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
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    database = [[FastFactsDB alloc] initWithName:@"FastFactsDB"];  // Initialize the database for the entire program.
    NSArray *result;
    
    if ([_subjectItem isEqualToString:@"Core Curriculum"])
        result = [database findByKeyword:@"CORE_CURRICULUM"];
    else if ([_subjectItem isEqualToString:@"Ethics Law Policy Health Systems"])
        result = [database findByKeyword:@"ETHICS_LAW_POLICY_HEALTH_SYSTEMS"];
    else if ([_subjectItem isEqualToString:@"Non-Pain Symptoms Syndromes"])
        result = [database findByKeyword:@"NON_PAIN_SYMPTOMS_SYNDROMES"];
    else if ([_subjectItem isEqualToString:@"Pain Evaluation"])
        result = [database findByKeyword:@"PAIN_EVALUATION"];
    else if ([_subjectItem isEqualToString:@"Pain (Non-Opioids)"])
        result = [database findByKeyword:@"PAIN_NON_OPIOIDS"];
    else if ([_subjectItem isEqualToString:@"Pain (Opioids)"])
        result = [database findByKeyword:@"PAIN_OPIOIDS"];
    else if ([_subjectItem isEqualToString:@"Psychosocial Spiritual Experience"])
        result = [database findByKeyword:@"PSYCHOSOCIAL_SPIRITUAL_EXPERIENCE"];
    else if ([_subjectItem isEqualToString:@"Other Neurological Disorders"])
        result = [database findByKeyword:@"OTHER_NEUROLOGICAL_DISORDERS"];
    else
        result = [database findByKeyword:_subjectItem];
    
    NSMutableArray *displayList2 = [NSMutableArray array];  //Dummy array for adding display elements easily.
    NSMutableArray *articleNumberList2 = [NSMutableArray array];
    
    for (NSArray *row in result) {
        NSString *object = [NSString stringWithFormat:@"%@: %@", [row objectAtIndex:NUMBER], [row objectAtIndex:SHORT_NAME]];
        [displayList2 addObject:object];
        [articleNumberList2 addObject:[row objectAtIndex:NUMBER]];
    }
    
    self.displayList = displayList2;
    self.articleNumberList = articleNumberList2;
    self.title = _subjectItem;
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
    
    else {
        NSDate *list = _displayList[indexPath.row];
        cell.textLabel.text = [list description];
    }
    
    return cell;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier: @"showDetail" sender: self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    DetailViewController *destViewController = segue.destinationViewController;
    destViewController.title = @"";
    
    indexPath = [self.tableView indexPathForSelectedRow];
    destViewController = [_displayList objectAtIndex:indexPath.row];
    [[segue destinationViewController] setDetailItem:[[_articleNumberList objectAtIndex:indexPath.row] integerValue]-1];
}

@end