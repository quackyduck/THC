//
//  HotelProfileViewController.m
//  THC
//
//  Created by Nicolas Melo on 7/30/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "HotelProfileViewController.h"
#import "Building.h"
#import "BuildingPhoto.h"
#import "Case.h"
#import "CaseCell.h"
#import "ViolationSubmissionViewController.h"

@interface HotelProfileViewController ()
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIImageView *hotelImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) Building *building;
@property (weak, nonatomic) IBOutlet UILabel *buildingLabel;
@property (strong, nonatomic) UIImage *buildingImage;
@property (strong, nonatomic) NSArray *cases;
@property (weak, nonatomic) IBOutlet UILabel *violationCountLabel;
@property (strong, nonatomic) CaseCell *stubCell;
@end

@implementation HotelProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithBuilding:(Building *)building andImage:(UIImage *)image {
    self = [self initWithNibName:nil bundle:nil];
    self.building = building;
    self.buildingImage = image;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.tableView.backgroundColor = [UIColor colorWithRed:224/255.0f green:232/255.0f blue:234/255.0f alpha:1.0f];
    
    PFQuery *query = [Case query];
    [query whereKey:@"buildingId" equalTo:self.building.objectId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"Get the building photo");
        if (!error) {
            self.cases = objects;
            self.violationCountLabel.text = [NSString stringWithFormat:@"Reported Violations (%lu)", (unsigned long)self.cases.count];
            [self.tableView reloadData];
        }
    }];

    self.hotelImageView.image = self.buildingImage;
    self.hotelImageView.backgroundColor = [UIColor clearColor];
    
//    CIImage *image = [[CIImage alloc] initWithImage:self.hotelImageView.image];
//    CIFilter *gradient = [CIFilter filterWithName:kCICategoryGradient];
//    
//    
//    [gradient setValue:image forKeyPath:kCIInputImageKey];
//    
//    self.hotelImageView.image = [UIImage imageWithCIImage:gradient.outputImage];
    
    CAGradientLayer *gradientMask = [CAGradientLayer layer];
    gradientMask.frame = self.hotelImageView.bounds;
    
    UIColor *startingColor = [UIColor blackColor];
    startingColor = [startingColor colorWithAlphaComponent:0.5f];
    UIColor *middleColor = [UIColor clearColor];
    
    gradientMask.colors = @[(id)startingColor.CGColor, (id)middleColor.CGColor, (id)middleColor.CGColor, (id)startingColor.CGColor];
    gradientMask.locations = @[@0.0, @0.25, @0.90, @1.0];

    [self.hotelImageView.layer insertSublayer:gradientMask atIndex:0];
    
    
    self.buildingLabel.text = self.building.buildingName;

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CaseCell" bundle:nil] forCellReuseIdentifier:@"CaseCell"];
    self.stubCell = [self.tableView dequeueReusableCellWithIdentifier:@"CaseCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.stubCell.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cases.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CaseCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CaseCell"];
    [cell initWithCase:self.cases[indexPath.row] showAssignment:NO enableScroll:NO containingTable:nil displayDescription:YES useGray:YES];
    return cell;
}
- (IBAction)onClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onCreateReport:(id)sender {
    ViolationSubmissionViewController *vsc = [[ViolationSubmissionViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vsc];
    nvc.navigationBar.barTintColor = [UIColor colorWithRed: 1 green: 0.455f blue: 0.184f alpha: 1];
    [self presentViewController:nvc animated:YES completion:nil];
}

@end
