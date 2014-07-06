//
//  CaseTableViewController.m
//  THC
//
//  Created by David Bernthal on 7/5/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "CaseTableViewController.h"
#import "CaseCell.h"
#import "Case.h"
#import "CaseDetailViewController.h"
#import <Parse/Parse.h>

@interface CaseTableViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *caseControl;
@property (weak, nonatomic) IBOutlet UITableView *caseTableView;

@property (nonatomic, strong) NSArray* cases;
@property (strong, nonatomic) UISearchBar* searchBar;

@property (strong, nonatomic) CaseCell* stubCell;

@end

@implementation CaseTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.caseControl addTarget:self
                             action:@selector(onCaseControlChange)
                   forControlEvents:UIControlEventValueChanged];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.caseTableView.dataSource = self;
    self.caseTableView.delegate = self;
    [self.caseTableView registerNib:[UINib nibWithNibName:@"CaseCell" bundle:nil] forCellReuseIdentifier:@"CaseCell"];
    self.stubCell = [self.caseTableView dequeueReusableCellWithIdentifier:@"CaseCell"];
    
    UIBarButtonItem *logOutButton = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(onLogOut)];
    self.navigationItem.leftBarButtonItem = logOutButton;
    UIBarButtonItem *reportButton = [[UIBarButtonItem alloc] initWithTitle:@"Report" style:UIBarButtonItemStylePlain target:self action:@selector(onReport)];
    self.navigationItem.rightBarButtonItem = reportButton;
    self.navigationItem.title = @"Cases";
    
    // Set Up Search Bar
    // temp values
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10.0, 0.0, 200.0, 44.0)];
    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.searchBar setKeyboardType:UIKeyboardTypeWebSearch];
    self.searchBar.delegate = self;
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 230.0, 44.0)];
    [searchBarView addSubview:self.searchBar];
    self.searchBar.alpha = 0;
    
    //Create test case (ha!)
//    Case* myCase = [Case object];
//    myCase.buildingId = @"xyz";
//    myCase.name = @"New Case";
//    myCase.address = @"Easy Street";
//    [myCase saveInBackground];
    
    [self loadEntries];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadEntries];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadEntries
{
    PFQuery *query = [Case query];
    //ALL THE CASES!!
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.cases = objects;
            [self.caseTableView reloadData];
        }
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cases.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    Once we have ALO constraints
//    [self.stubCell initWithCase:self.cases[indexPath.row]];
//    [self.stubCell layoutSubviews];
//    
//    CGSize size = [self.stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    return size.height+1;
    return 127;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewAutomaticDimension;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CaseCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CaseCell"];
    [cell initWithCase:self.cases[indexPath.row]];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CaseDetailViewController *detailvc = [[CaseDetailViewController alloc] initWithCase:self.cases[indexPath.row]];
    [self.navigationController pushViewController:detailvc animated:YES];
}

- (void)onCaseControlChange
{
    switch (self.caseControl.selectedSegmentIndex) {
        case 0:
        {
            //Get 10 newest cases
            PFQuery *query = [Case query];
            [query orderByDescending:@"createdAt"];
            query.limit = 10;
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    self.cases = objects;
                    [self.caseTableView reloadData];
                }
            }];
        }
            break;
        case 1:
        {
            //Get my cases
            PFQuery *query = [Case query];
            [query whereKey:@"userId" equalTo:@"get current user"];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    self.cases = objects;
                    [self.caseTableView reloadData];
                }
            }];
        }
            break;
        case 2:
            //Show search bar?
            self.searchBar.alpha = 1;
            break;
            
        default:
            break;
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    self.caseTableView.allowsSelection = NO;
    self.caseTableView.scrollEnabled = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.caseTableView.allowsSelection = YES;
    self.caseTableView.scrollEnabled = YES;
    [self loadEntries];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.caseTableView.allowsSelection = YES;
    self.caseTableView.scrollEnabled = YES;
	
    PFQuery *query = [Case query];
    [query whereKey:@"caseId" equalTo:searchBar.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.cases = objects;
            [self.caseTableView reloadData];
        }
    }];
}

- (void)onLogOut
{
}

- (void)onReport
{
//    ComposeViewController *composeVC = [[ComposeViewController alloc] init];
//    [self.navigationController pushViewController:composeVC animated:YES];
}

@end
