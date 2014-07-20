//
//  SubmissionValidationViewController.m
//  THC
//
//  Created by David Bernthal on 7/19/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "SubmissionValidationViewController.h"
#import "PhotoInfo.h"
#import "Building.h"

@interface SubmissionValidationViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *checkMarkImageView;
@property (weak, nonatomic) IBOutlet UIImageView *violationImageView;
@property (weak, nonatomic) IBOutlet UILabel *violationLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

@property (strong, nonatomic) Case *myCase;
@property (strong, nonatomic) UIImage *firstPhoto;

@end

@implementation SubmissionValidationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCase:(Case *)myCase withTopPhoto:(UIImage *)firstPhoto
{
    self = [self initWithNibName:@"SubmissionValidationViewController" bundle:nil];
    if (self) {
        self.myCase = myCase;
        self.firstPhoto = firstPhoto;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor * orangeNavBarColor = [UIColor orangeColor];
    
    self.navigationController.navigationBar.barTintColor = orangeNavBarColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"Violation Submitted";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_photoGallery_active"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissView)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_nav_back_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(backToEditView)];
    
    [self.violationImageView setImage:self.firstPhoto];
            
    self.violationImageView.layer.cornerRadius = 98;
    self.violationImageView.layer.masksToBounds = YES;
    [self.violationImageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [self.violationImageView.layer setBorderWidth: 5.0];
    
    UIImage* checkImage = [UIImage imageNamed:@"Confirmation"];
    [self.checkMarkImageView setImage:checkImage];
    
    //Use buildingId to query for building name
    PFQuery *query = [Building query];
    [query whereKey:@"objectId" equalTo:self.myCase.buildingId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0)
            {
                Building* building = objects[0];
                ///TODO Change to violation type?
                self.violationLabel.text = [NSString stringWithFormat:@"%@ at %@", self.myCase.name, building.buildingName];
            }
        }
    }];
    
    self.summaryLabel.text = [NSString stringWithFormat:@"Summary of Case #%@", self.myCase.caseId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backToEditView
{
    
}

@end
