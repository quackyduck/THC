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
#import "CaseDetailViewController.h"
#import "AggregateMapViewController.h"
#import <Parse/Parse.h>

@interface CaseTableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *caseTableView;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;
@property (weak, nonatomic) IBOutlet UILabel *openLabel;
@property (weak, nonatomic) IBOutlet UILabel *myLabel;

@property (nonatomic, strong) NSArray* cases;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) CaseCell* stubCell;

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
    
    //Create test case (ha!)
//    Case* myCase = [Case object];
//    myCase.caseId = @"test1";
//    myCase.buildingId = @"xyz";
//    myCase.name = @"New Case";
//    myCase.address = @"Easy Street";
//    myCase.unit = @"C16";
//    myCase.phoneNumber = @"123-456-7890";
//    myCase.email = @"test@aol.com";
//    myCase.languageSpoken = @"Klingon";
//    myCase.description = @"blah";
//    myCase.userId = @"xyz";
//    myCase.status = caseOpen;
//    [myCase saveInBackground];
    
    //Test photo
//    UIImage *test = [UIImage imageNamed:@"Test Photo"];
//    UIImageView *testImageView = [[UIImageView alloc] initWithImage:test];
//    PhotoInfo* testPhoto = [PhotoInfo object];
//    testPhoto.caseId = @"test1";
//    testPhoto.caption = @"CAPTION!!";
//    
//    NSData* data = UIImageJPEGRepresentation(testImageView.image, 0.5f);
//    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:data];
//    testPhoto.image = imageFile;
//    [testPhoto saveInBackground];
    
    [self loadEntries];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
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
    CaseDetailViewController *detailvc = [[CaseDetailViewController alloc] initWithCase:self.cases[indexPath.row] isNewCase:NO];
    [self.navigationController pushViewController:detailvc animated:YES];
}

- (void)queryForCases:(PFQuery *)query
{
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.cases = objects;
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
    [self loadEntries];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.caseTableView.allowsSelection = YES;
    self.caseTableView.scrollEnabled = YES;
	
    PFQuery *query = [Case query];
    [query whereKey:@"caseId" equalTo:searchBar.text];
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
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    self.openLabel.attributedText = [[NSAttributedString alloc] initWithString:@"Open Cases"
                                                             attributes:underlineAttribute];
    self.allLabel.text = @"All Cases"; // remove underline
    self.myLabel.text = @"My Cases"; // remove underline
    
    //Get 10 newest cases, need to instead just look for open cases?
    PFQuery *query = [Case query];
    [query orderByDescending:@"createdAt"];
    query.limit = 10;
    [self queryForCases:query];
}

- (IBAction)onMyTap:(id)sender {
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    self.myLabel.attributedText = [[NSAttributedString alloc] initWithString:@"My Cases"
                                                                   attributes:underlineAttribute];
    self.openLabel.text = @"Open Cases"; // remove underline
    self.allLabel.text = @"All Cases"; // remove underline
    
    //Get my cases
    PFQuery *query = [Case query];
    PFUser *user = [PFUser currentUser];
    [query whereKey:@"userId" equalTo:user.objectId];
    [self queryForCases:query];
}

- (IBAction)onAllTap:(id)sender {
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    self.allLabel.attributedText = [[NSAttributedString alloc] initWithString:@"All Cases"
                                                                   attributes:underlineAttribute];
    self.openLabel.text = @"Open Cases"; // remove underline
    self.myLabel.text = @"My Cases"; // remove underline
    
    PFQuery *query = [Case query];
    //ALL THE CASES!!
    [self queryForCases:query];
    
}
@end
