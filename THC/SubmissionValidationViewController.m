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
#import "ExploreCasesContainerViewController.h"

@interface SubmissionValidationViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *checkMarkImageView;
@property (weak, nonatomic) IBOutlet UIImageView *violationImageView;
@property (weak, nonatomic) IBOutlet UILabel *violationLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UIView *cloudsView;

@property (strong, nonatomic) Case *myCase;
@property (strong, nonatomic) UIImage *firstPhoto;
@property(strong, nonatomic) UIImageView *cloudImageView3;
@property(strong, nonatomic) UIImageView *cloudImageView4;
@property(assign, nonatomic) CGFloat screenWidth;

- (IBAction)onDownSwipe:(UISwipeGestureRecognizer *)sender;

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
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.screenWidth = screenRect.size.width;
    
    UIColor * orangeNavBarColor = [UIColor colorWithRed: 1 green: 0.455f blue: 0.184f alpha: 1];
    
    self.view.backgroundColor = orangeNavBarColor;
//    self.navigationController.navigationBar.barTintColor = orangeNavBarColor;
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    self.navigationItem.title = @"Violation Submitted";
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
//    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_nav_check_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissView)];
//    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_nav_back_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(backToEditView)];
    
    [self.violationImageView setImage:self.firstPhoto];
            
    self.violationImageView.layer.cornerRadius = 98;
    self.violationImageView.layer.masksToBounds = YES;
    [self.violationImageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [self.violationImageView.layer setBorderWidth: 5.0];
    
    UIImage* checkImage = [UIImage imageNamed:@"ic_success"];
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
    
    UIImage *cloud1 = [UIImage imageNamed:@"clouds2"];
    self.cloudImageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cloud1.size.width, cloud1.size.height)];
    self.cloudImageView3.image = cloud1;
    
    self.cloudImageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(320, 0, cloud1.size.width, cloud1.size.height)];
    self.cloudImageView4.image = cloud1;
    
    self.cloudImageView3.alpha = 0;
    self.cloudImageView4.alpha = 0;
    
    [self.cloudsView addSubview:self.cloudImageView3];
    [self.cloudsView addSubview:self.cloudImageView4];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [self cloudAnimation:self.cloudImageView3 firstDuration:8 secondDuration:16];
    [self cloudAnimation:self.cloudImageView4 firstDuration:16 secondDuration:16];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cloudAnimation:(UIImageView *)cloud firstDuration:(NSInteger)firstDuration secondDuration:(NSInteger)secondDuration   {
    [UIView animateWithDuration:firstDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        NSLog(@"current x %f, %f", cloud.center.x, -cloud.frame.size.width / 2);
        cloud.alpha = 0.3f;
        cloud.center = CGPointMake(-cloud.frame.size.width / 2, cloud.center.y);
    } completion:^(BOOL finished) {
        NSLog(@"skdfjsdf %f", cloud.center.x);
        cloud.center = CGPointMake(self.screenWidth + cloud.frame.size.width / 2, cloud.center.y);
        [UIView animateWithDuration:secondDuration delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat animations:^{
            cloud.center = CGPointMake(-cloud.frame.size.width / 2, cloud.center.y);
        } completion:nil];
    }];
}

- (IBAction)dismissView:(id)sender
{
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//    [self dismissViewControllerAnimated:YES completion:nil];
//    ExploreCasesContainerViewController *xvc = [[ExploreCasesContainerViewController alloc] init];
//    [self presentViewController:xvc animated:NO completion:nil];
}

- (void)backToEditView
{
    
}

- (IBAction)onDownSwipe:(UISwipeGestureRecognizer *)sender {
    [self dismissView:self];
}
@end
