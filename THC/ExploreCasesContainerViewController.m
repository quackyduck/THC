//
//  ExploreCasesContainerViewController.m
//  THC
//
//  Created by Nicolas Melo on 7/12/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "ExploreCasesContainerViewController.h"
#import "AggregateMapViewController.h"
#import "CaseTableViewController.h"
#import "ViolationSubmissionViewController.h"

@interface ExploreCasesContainerViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *createReportButton;
@property (strong, nonatomic) NSArray *tabViewControllers;
@property (weak, nonatomic) IBOutlet UIView *dividerView;
@property (weak, nonatomic) IBOutlet UIButton *casesButton;
@property (weak, nonatomic) IBOutlet UIButton *nearbyButton;


- (IBAction)onCreateReport:(id)sender;
- (IBAction)onNearbyTab:(id)sender;
- (IBAction)onCasesTab:(id)sender;

@end

@implementation ExploreCasesContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        AggregateMapViewController *mapViewController = [[AggregateMapViewController alloc] init];
        CaseTableViewController *casesViewController = [[CaseTableViewController alloc] init];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:casesViewController];
        self.tabViewControllers = @[mapViewController, nvc];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self selectedNearbyButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)selectedNearbyButton {
    UIColor *selectedColor = [UIColor colorWithRed:35/255.0f green:41/255.0f blue:52/255.0f alpha:1.0f];
    UIColor *unselectedColor = [UIColor colorWithRed:149/255.0f green:150/255.0f blue:151/255.0f alpha:1.0f];
    
    self.nearbyButton.imageView.image = [UIImage imageNamed:@"ic_nav_map_selected"];
    self.nearbyButton.titleLabel.textColor = selectedColor;
    
    self.casesButton.imageView.image = [UIImage imageNamed:@"ic_nav_cases_normal"];
    self.casesButton.titleLabel.textColor = unselectedColor;
    
    AggregateMapViewController *mapsViewController = self.tabViewControllers[0];
    UINavigationController *nvc = self.tabViewControllers[1];
    
    [self show:mapsViewController andRemove:nvc];
    
}

- (void)selectedCasesButton {
    UIColor *selectedColor = [UIColor colorWithRed:35/255.0f green:41/255.0f blue:52/255.0f alpha:1.0f];
    UIColor *unselectedColor = [UIColor colorWithRed:149/255.0f green:150/255.0f blue:151/255.0f alpha:1.0f];
    
    self.nearbyButton.imageView.image = [UIImage imageNamed:@"ic_nav_map_normal"];
    self.nearbyButton.titleLabel.textColor = unselectedColor;
    
    self.casesButton.imageView.image = [UIImage imageNamed:@"ic_nav_cases_selected"];
    self.casesButton.titleLabel.textColor = selectedColor;
    
    AggregateMapViewController *mapsViewController = self.tabViewControllers[0];
    UINavigationController *nvc = self.tabViewControllers[1];
    
    [self show:nvc andRemove:mapsViewController];
}

- (void)show:(UIViewController *)newChild andRemove:(UIViewController *)oldChild {

    [oldChild.view removeFromSuperview];
    [oldChild removeFromParentViewController];
    
    UIColor *backgroundColor = [UIColor colorWithRed:231/255.0f green:232/255.0f blue:234/255.0f alpha:1.0f];
    UIColor *dividerColor = [UIColor colorWithRed:205/255.0f green:205/255.0f blue:205/255.0f alpha:1.0f];

    self.view.backgroundColor = backgroundColor;
    self.dividerView.backgroundColor = dividerColor;
    
    newChild.view.frame = self.containerView.bounds;
    [self.containerView addSubview:newChild.view];
    [self addChildViewController:newChild];
    [newChild didMoveToParentViewController:self];
}

- (IBAction)onCreateReport:(id)sender {
    NSLog(@"Create new report.");
    NSLog(@"creating violation submission controller %@", self.navigationController);
    ViolationSubmissionViewController *vsc = [[ViolationSubmissionViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vsc];
    nvc.navigationBar.barTintColor = [UIColor colorWithRed: 0.196f green: 0.325f blue: 0.682f alpha: 1];

    [self presentViewController:nvc animated:YES completion:nil];
}

- (IBAction)onNearbyTab:(id)sender {
    [self selectedNearbyButton];
    
}

- (IBAction)onCasesTab:(id)sender {
    [self selectedCasesButton];
    
}
@end
