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
#import "CameraLauncher.h"
#import "PhotoInfo.h"
#import "AggregateMapViewController.h"
#import <Parse/Parse.h>
#import "CaseViewController.h"
#import "SubmissionValidationViewController.h"

@interface CaseTableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *caseTableView;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;
@property (weak, nonatomic) IBOutlet UIView *allView;
@property (weak, nonatomic) IBOutlet UILabel *openLabel;
@property (weak, nonatomic) IBOutlet UIView *openView;
@property (weak, nonatomic) IBOutlet UILabel *myLabel;
@property (weak, nonatomic) IBOutlet UIView *myView;
@property (weak, nonatomic) IBOutlet UIImageView *searchImage;

@property (nonatomic, strong) NSMutableArray* cases;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) CaseCell* stubCell;
@property (strong, nonatomic) CALayer* bottomBorder;

@end

@implementation CaseTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchBar.hidden = YES;
    
    self.searchImage.image = [UIImage imageNamed:@"Search"];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAllTap:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.allLabel addGestureRecognizer:tapGestureRecognizer];
    self.allLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *openTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onOpenTap:)];
    openTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.openLabel addGestureRecognizer:openTapGestureRecognizer];
    self.openLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *myTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMyTap:)];
    myTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.myLabel addGestureRecognizer:myTapGestureRecognizer];
    self.myLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *searchImageTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSearchTap:)];
    searchImageTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.searchImage addGestureRecognizer:searchImageTapGestureRecognizer];
    self.searchImage.userInteractionEnabled = YES;
    
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
    [self.searchBar setKeyboardType:UIKeyboardTypeWebSearch];
    self.searchBar.delegate = self;
    
    self.navigationController.navigationBar.hidden = YES;
    
    [self loadEntries];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    [self loadEntries];
    [self getNew];
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
            self.cases = [NSMutableArray arrayWithArray:objects];;
            [self.caseTableView reloadData];
        }
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cases.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.stubCell.frame.size.height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CaseCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CaseCell"];
    [cell initWithCase:self.cases[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Case *caseInfo = self.cases[indexPath.row];
    CaseViewController *detailvc = [[CaseViewController alloc] initWithCase:caseInfo];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:detailvc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)queryForCases:(PFQuery *)query
{
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.cases = [NSMutableArray arrayWithArray:objects];;
            [self.caseTableView reloadData];
        }
    }];
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
    [self removeSearchBar];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.caseTableView.allowsSelection = YES;
    self.caseTableView.scrollEnabled = YES;
	
    PFQuery *query = [Case query];
    [query whereKey:@"objectId" equalTo:searchBar.text];
    [self queryForCases:query];
}

- (void)onLogOut
{
    [PFUser logOut];
    AggregateMapViewController *aggregateViewController = [[AggregateMapViewController alloc] init];
    [self.navigationController pushViewController:aggregateViewController animated:YES];
    
}

- (void)onReport
{
    CameraLauncher *launcher = [[CameraLauncher alloc] init];
    [self.navigationController pushViewController:launcher animated:YES];
    [launcher launchCamera];
}

- (IBAction)onOpenTap:(id)sender {
    [self getNew];
}

- (IBAction)onMyTap:(id)sender {
    self.myLabel.textColor = [UIColor orangeColor];
    self.allLabel.textColor = [UIColor grayColor];
    self.openLabel.textColor = [UIColor grayColor];
    [self addBottomBorder:self.myView];
    
    //Get my cases
    PFQuery *query = [Case query];
    PFUser *user = [PFUser currentUser];
    [query whereKey:@"userId" equalTo:user.objectId];
    [query whereKey:@"status" equalTo:@0];
    [self queryForCases:query];
}

- (IBAction)onAllTap:(id)sender {
    self.allLabel.textColor = [UIColor orangeColor];
    self.openLabel.textColor = [UIColor grayColor];
    self.myLabel.textColor = [UIColor grayColor];
    [self addBottomBorder:self.allView];
    
    PFQuery *query = [Case query];
    //ALL THE CASES!!
    [self queryForCases:query];
}

- (void)addBottomBorder:(UIView*)superView {
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, superView.frame.size.height - 1.0f, superView.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor orangeColor].CGColor;
    [superView.layer addSublayer:bottomBorder];
    [self.bottomBorder removeFromSuperlayer];
    self.bottomBorder = bottomBorder;
}

- (void)removeSearchBar
{
    // get the height of the search bar
    CGFloat delta = self.searchBar.frame.size.width + 14.f;

    delta *= -1;
    
    // run animation 0.7 second and no delay
    [UIView animateWithDuration:0.7 delay: 0.0 options: UIViewAnimationOptionCurveEaseIn animations:^{
        // move search bar delta units up or down
        self.searchBar.frame = CGRectOffset(self.searchBar.frame, (float) delta, 0.0);
    } completion:^(BOOL finished) {
//        self.searchBar.hidden = YES;
    }];
}


- (IBAction)onSearchTap:(id)sender {
    // get the height of the search bar
    CGFloat delta = self.searchBar.frame.size.width + 14;
    
    // if search bar was hidden then make it visible
    self.searchBar.hidden = NO;
    [self.searchBar becomeFirstResponder];
    
    // run animation 0.7 second and no delay
    [UIView animateWithDuration:0.5 delay: 0.0 options: UIViewAnimationOptionCurveEaseIn animations:^{
        // move search bar delta units up or down
        self.searchBar.frame = CGRectOffset(self.searchBar.frame, delta, 0.0);
    } completion:nil];
    
}

- (void)getNew
{
    self.openLabel.textColor = [UIColor orangeColor];
    self.allLabel.textColor = [UIColor grayColor];
    self.myLabel.textColor = [UIColor grayColor];
    [self addBottomBorder:self.openView];
    
    PFQuery *query = [Case query];
    [query whereKey:@"status" equalTo:@0];
    [query orderByDescending:@"createdAt"];
    [self queryForCases:query];
}

//Closing code
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.caseTableView setEditing:editing animated:animated];
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        //Close the case
        Case *caseInfo = self.cases[indexPath.row];
        caseInfo.status = caseClosed;
        [caseInfo saveInBackground];
        
        [self.cases removeObjectAtIndex:indexPath.row];
        
        /* Then remove the associated cell from the Table View */
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
    
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"Close";
}


@end
