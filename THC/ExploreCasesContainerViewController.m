//
//  ExploreCasesContainerViewController.m
//  THC
//
//  Created by Nicolas Melo on 7/12/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "ExploreCasesContainerViewController.h"
#import "AggregateMapViewController.h"
#import "ViolationSubmissionViewController.h"
#import "HappySunViewController.h"
#import "AssignmentViewController.h"
#import "HotelProfileViewController.h"
#import "HotelProfileTransition.h"

@interface ExploreCasesContainerViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *createReportButton;
@property (strong, nonatomic) NSArray *tabViewControllers;
@property (weak, nonatomic) IBOutlet UIView *dividerView;
@property (weak, nonatomic) IBOutlet UIButton *casesButton;
@property (weak, nonatomic) IBOutlet UIButton *nearbyButton;
@property (assign, nonatomic) BOOL onExploreTab;

@property BOOL isShowingAssignments;


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
        casesViewController.delegate = self;
        HappySunViewController *happySunViewController = [[HappySunViewController alloc] init];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:casesViewController];
        self.tabViewControllers = @[mapViewController, nvc, happySunViewController];
        self.onExploreTab = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.containerView.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.containerView.layer setShadowOpacity:.35f];
    [self.containerView.layer setShadowRadius:1];
    [self.containerView.layer setShadowOffset:CGSizeMake(1, 1)];
    
    [self.createReportButton.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.createReportButton.layer setShadowOpacity:.35f];
    [self.createReportButton.layer setShadowRadius:1];
    [self.createReportButton.layer setShadowOffset:CGSizeMake(1, 1)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHotelView:) name:@"CalloutTapped" object:nil];
    
}

- (void)showHotelView:(NSNotification *)obj {
    
    NSDictionary *userInfo = obj.userInfo;
    UIImage *image = userInfo[@"image"];
    Building *building = userInfo[@"building"];
    
    HotelProfileViewController *hpvc = [[HotelProfileViewController alloc] initWithBuilding:building andImage:image];
    
    hpvc.modalPresentationStyle = UIModalPresentationCustom;
    HotelProfileTransition *transition = [[HotelProfileTransition alloc] init];
    hpvc.transitioningDelegate = transition;

    [self presentViewController:hpvc animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    NSLog(@"View will appear for the explore cases!!");
    
    if (!self.onExploreTab) {
        PFUser *currentUser = [PFUser currentUser];
        if (currentUser) {
            [self selectedCasesButton];
            
        } else {
            NSLog(@"No user logged in.");
        }
    } else {
        [self selectedNearbyButton];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectedNearbyButton {
    self.onExploreTab = YES;
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
    self.onExploreTab = NO;
    UIColor *selectedColor = [UIColor colorWithRed:35/255.0f green:41/255.0f blue:52/255.0f alpha:1.0f];
    UIColor *unselectedColor = [UIColor colorWithRed:149/255.0f green:150/255.0f blue:151/255.0f alpha:1.0f];
    
    self.nearbyButton.imageView.image = [UIImage imageNamed:@"ic_nav_map_normal"];
    self.nearbyButton.titleLabel.textColor = unselectedColor;
    
    self.casesButton.imageView.image = [UIImage imageNamed:@"ic_nav_cases_selected"];
    self.casesButton.titleLabel.textColor = selectedColor;
    
    AggregateMapViewController *mapsViewController = self.tabViewControllers[0];
    UINavigationController *nvc = self.tabViewControllers[1];
    nvc.navigationBar.hidden = YES;
    HappySunViewController *happySunVC = self.tabViewControllers[2];
    if ([PFUser currentUser] != nil)
    {
        [self show:nvc andRemove:mapsViewController];
    } else
    {
        [self show:happySunVC andRemove:mapsViewController];
    }
    
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
    ViolationSubmissionViewController *vsc = [[ViolationSubmissionViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vsc];
    nvc.navigationBar.barTintColor = [UIColor colorWithRed: 1 green: 0.455f blue: 0.184f alpha: 1];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (IBAction)onNearbyTab:(id)sender {
    [self selectedNearbyButton];
}

- (IBAction)onCasesTab:(id)sender {
    [self selectedCasesButton];
}

- (void)showAssignmentView:(Case *)swipedCase
{
    UIImage *image = [UIImage imageNamed:@"ic_nav_map_selected"];
    AssignmentViewController *assignmentvc = [[AssignmentViewController alloc] initWithCase:swipedCase];
    assignmentvc.modalTransitionStyle = UIModalPresentationCustom;
    assignmentvc.transitioningDelegate = self;
    assignmentvc.delegate = self;
    [self presentViewController:assignmentvc animated:YES completion:nil];
}

- (void)reloadTable {
    //reload case table
//    [self.tableView reloadData];
}

#pragma mark - Transition Delegate Methods

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.isShowingAssignments = YES;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.isShowingAssignments = NO;
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 2.0;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIView* containerView = [transitionContext containerView];
    UIViewController* fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    
    if (self.isShowingAssignments)
    {
        toVC.view.frame = containerView.frame;
        [containerView addSubview:fromVC.view];
        [containerView addSubview:toVC.view];
        toVC.view.alpha = 0;
        toVC.view.frame = CGRectMake(320, 0, 320, 570);
        [UIView animateWithDuration:0.2 animations:^{
            toVC.view.frame = CGRectMake(0, 0, 320, 570);
            toVC.view.alpha = 1;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else
    {
        [UIView animateWithDuration:0.2 animations:^{
            fromVC.view.frame = CGRectMake(320, 0, 320, 570);
            fromVC.view.alpha = 0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

@end







