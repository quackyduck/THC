//
//  CaseViewController.m
//  THC
//
//  Created by Nicolas Melo on 7/18/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "CaseViewController.h"
#import "Case.h"
#import "DetailContentTableViewCell.h"
#import "ContactInfoCell.h"
#import "DetailViewTableHeader.h"
#import "ContactInfoButton.h"

@interface CaseViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Case *caseInfo;
@property (strong, nonatomic) DetailViewTableHeader *offscreenHeaderView;
@property (strong, nonatomic) DetailContentTableViewCell *offscreenDetailCell;
@property (strong, nonatomic) ContactInfoCell *offscreenContactDetailCell;
@property (strong, nonatomic) UIImage *emailImageNormal;
@property (strong, nonatomic) UIImage *emailImagePressed;
@property (strong, nonatomic) UIImage *phoneImageNormal;
@property (strong, nonatomic) UIImage *phoneImagePressed;

@end

@implementation CaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.emailImageNormal = [UIImage imageNamed:@"ic_nav_email_normal"];
        self.emailImagePressed = [UIImage imageNamed:@"ic_nav_email_pressed"];
        self.phoneImageNormal = [UIImage imageNamed:@"ic_nav_phone_normal"];
        self.phoneImagePressed = [UIImage imageNamed:@"ic_nav_phone_pressed"];
    }
    return self;
}

- (id)initWithCase:(Case *)caseInfo {
    
    self.caseInfo = caseInfo;
    return [self initWithNibName:nil bundle:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UIColor * orangeNavBarColor = [UIColor colorWithRed:255/255.0f green:116/255.0f blue:47/255.0f alpha:1.0f];

    self.navigationController.navigationBar.barTintColor = orangeNavBarColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = [NSString stringWithFormat:@"Case #%@", self.caseInfo.objectId];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_nav_edit_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(editForm:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_nav_close_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissView:)];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Detail cells
    UINib *detailNib = [UINib nibWithNibName:@"DetailContentTableViewCell" bundle:nil];
    NSArray *detailNibs = [detailNib instantiateWithOwner:nil options:nil];
    self.offscreenDetailCell = detailNibs[0];
    [self.tableView registerNib:detailNib forCellReuseIdentifier:@"DetailContentTableViewCell"];
    
    
    // Email and Phone button cells
    UINib *contactNib = [UINib nibWithNibName:@"ContactInfoCell" bundle:nil];
    NSArray *contactNibs = [contactNib instantiateWithOwner:nil options:nil];
    self.offscreenContactDetailCell = contactNibs[0];
    [self.tableView registerNib:contactNib forCellReuseIdentifier:@"ContactInfoCell"];
    
    
    // Header views
    UINib *headerNib = [UINib nibWithNibName:@"DetailViewTableHeader" bundle:nil];
    NSArray *nibs = [headerNib instantiateWithOwner:nil options:nil];
    self.offscreenHeaderView = nibs[0];
    [self.tableView registerNib:headerNib forHeaderFooterViewReuseIdentifier:@"TableHeader"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)editForm:(id)sender {
    
}

- (void)dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    [self.offscreenHeaderView layoutSubviews];
    CGFloat height = [self.offscreenHeaderView.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    NSLog(@"Height of header view: %f", height);
    
    return height + 1;
//    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    // last section gets an email button
    if (section == 4) {
        return 150;
    }
    
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    DetailViewTableHeader *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TableHeader"];
    
    switch (section) {
        case 0:
            headerView.headerTitleLabel.text = @"Tenant Information";
            break;
        case 1:
            headerView.headerTitleLabel.text = @"Hotel Information";
            break;
        case 2:
            headerView.headerTitleLabel.text = @"Violation Description";
            break;
        case 3:
            headerView.headerTitleLabel.text = @"Attached Photos";
            break;
        case 4:
            headerView.headerTitleLabel.text = @"Notes";
            break;
        default:
            NSLog(@"Not good, we ran out of options.");
            break;
    }
    
    return headerView;
    
}

- (void)configureDetailCell:(DetailContentTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {

            cell.titleLabel.text = @"Tenant Name";
            cell.contentLabel.text = @"Nicolas Melo";
            
        } else if (indexPath.row == 1) {
            cell.titleLabel.text = @"Tenant Name";
            cell.contentLabel.text = @"Nicolas Melo";
            
        }
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"Tenant Name";
            cell.contentLabel.text = @"Nicolas Melo";
            
        } else if (indexPath.row == 1) {
            cell.titleLabel.text = @"Tenant Name";
            cell.contentLabel.text = @"Nicolas Melo";
            
        }
        
    } else if (indexPath.section == 2) {
        cell.titleLabel.text = @"Reported 3 months ago";
        cell.contentLabel.text = @"Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et.";
        
    } else if (indexPath.section == 4) {
        cell.titleLabel.text = @"Tenant Name";
        cell.contentLabel.text = @"Nicolas Melo";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((indexPath.section == 0 && indexPath.row == 2) || (indexPath.section == 1 && indexPath.row == 2)) {
        [self.offscreenContactDetailCell layoutSubviews];
        CGFloat height = [self.offscreenContactDetailCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        NSLog(@"Layout email and phone buttons at height %f", height);
        return height + 1;
    } else if (indexPath.section == 3) {
        NSLog(@"Photos");
        return 100;
    }
    
    [self configureDetailCell:self.offscreenDetailCell forRowAtIndexPath:indexPath];
    [self.offscreenDetailCell layoutSubviews];
    CGFloat height = [self.offscreenDetailCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    NSLog(@"Layout detail cells at height %f", height);
    return height + 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < 2) {
        return 3;
    } else {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            DetailContentTableViewCell *detailCell = [self.tableView dequeueReusableCellWithIdentifier:@"DetailContentTableViewCell"];
            [self configureDetailCell:detailCell forRowAtIndexPath:indexPath];
            return detailCell;
            
        } else if (indexPath.row == 1) {
            DetailContentTableViewCell *detailCell = [self.tableView dequeueReusableCellWithIdentifier:@"DetailContentTableViewCell"];
            [self configureDetailCell:detailCell forRowAtIndexPath:indexPath];
            return detailCell;
            
        } else {
            ContactInfoCell *contactInfoCell = [self.tableView dequeueReusableCellWithIdentifier:@"ContactInfoCell"];
            return contactInfoCell;
            
        }
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            DetailContentTableViewCell *detailCell = [self.tableView dequeueReusableCellWithIdentifier:@"DetailContentTableViewCell"];
            [self configureDetailCell:detailCell forRowAtIndexPath:indexPath];
            return detailCell;
            
        } else if (indexPath.row == 1) {
            DetailContentTableViewCell *detailCell = [self.tableView dequeueReusableCellWithIdentifier:@"DetailContentTableViewCell"];
            [self configureDetailCell:detailCell forRowAtIndexPath:indexPath];
            return detailCell;
            
        } else {
            ContactInfoCell *contactInfoCell = [self.tableView dequeueReusableCellWithIdentifier:@"ContactInfoCell"];
            return contactInfoCell;
            
        }
        
    } else if (indexPath.section == 2) {
        DetailContentTableViewCell *detailCell = [self.tableView dequeueReusableCellWithIdentifier:@"DetailContentTableViewCell"];
        [self configureDetailCell:detailCell forRowAtIndexPath:indexPath];
        return detailCell;
        
    } else if (indexPath.section == 3) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = @"Boom!";
        
        return cell;
        
    } else if (indexPath.section == 4) {
        DetailContentTableViewCell *detailCell = [self.tableView dequeueReusableCellWithIdentifier:@"DetailContentTableViewCell"];
        [self configureDetailCell:detailCell forRowAtIndexPath:indexPath];
        return detailCell;
        
    }

    return nil;
}

@end
