//
//  AssignmentViewController.m
//  THC
//
//  Created by David Bernthal on 7/26/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "AssignmentViewController.h"
#import "AssignmentsCell.h"
#import "Case.h"
#import <Parse/Parse.h>

@interface AssignmentViewController ()

@property (weak, nonatomic) IBOutlet UITableView *assignmentTableView;

@property (nonatomic, strong) NSMutableArray* assignments;
- (IBAction)onCancel:(id)sender;

@end

@implementation AssignmentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCase:(Case*)assignToCase backgroundImage:(UIImage*)image
{
    self = [self initWithNibName:@"AssignmentViewController" bundle:nil];
    if (self) {
        self.assignToCase = assignToCase;
    }
    return self;
}

- (id)initWithCase:(Case *)assignToCase {
    self = [self initWithCase:assignToCase backgroundImage:nil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.assignmentTableView.dataSource = self;
    self.assignmentTableView.delegate = self;
    [self.assignmentTableView registerNib:[UINib nibWithNibName:@"AssignmentsCell" bundle:nil] forCellReuseIdentifier:@"AssignmentsCell"];
    self.assignmentTableView.backgroundColor = [UIColor blackColor];
    self.assignmentTableView.alpha = 0.5;
    self.assignmentTableView.layer.borderWidth = 1.0;
    self.assignmentTableView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.assignmentTableView.layer.cornerRadius = 10;
    
    PFQuery *query = [PFUser query];
//    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.assignments = [[NSMutableArray alloc] init];
            NSMutableArray* users = [NSMutableArray arrayWithArray:objects];
            for (NSObject* user in users)
            {
                PFUser* pfUser = (PFUser*)user;
                
                Assignment *assignment = [[Assignment alloc] initWithUser:pfUser andCurrentCount:[[NSNumber alloc] initWithInt:3]];
                [self.assignments addObject:assignment];
            }
            [self.assignmentTableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assignments.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssignmentsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AssignmentsCell"];
    [cell initWithAssignment:self.assignments[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Assignment *assignment = self.assignments[indexPath.row];
    
    //Send API assignment update to case
    self.assignToCase.userId = assignment.userId;
    [self.assignToCase saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        //Dismiss this modal view
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
