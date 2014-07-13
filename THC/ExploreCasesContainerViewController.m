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
#import "ExploreTabBarItem.h"

@interface ExploreCasesContainerViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *createReportView;
@property (weak, nonatomic) IBOutlet ExploreTabBarItem *exploreTabBar;
@property (weak, nonatomic) IBOutlet UIButton *createReportButton;
@property (strong, nonatomic) NSArray *tabViewControllers;
@property (weak, nonatomic) IBOutlet UIView *containerBackgroundView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;
- (IBAction)onTapTabBar:(UITapGestureRecognizer *)sender;

- (IBAction)onCreateReport:(id)sender;



@end

@implementation ExploreCasesContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        AggregateMapViewController *mapViewController = [[AggregateMapViewController alloc] init];
        CaseTableViewController *casesViewController = [[CaseTableViewController alloc] init];
        self.tabViewControllers = @[mapViewController, casesViewController];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    AggregateMapViewController *mapsViewController = self.tabViewControllers[0];
    CaseTableViewController *casesViewController = self.tabViewControllers[1];
    
    [self show:mapsViewController andRemove:casesViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)show:(UIViewController *)newChild andRemove:(UIViewController *)oldChild {

    [oldChild.view removeFromSuperview];
    [oldChild removeFromParentViewController];
    
    UIColor *backgroundColor;
    UIColor *tabColor;
    
    UIColor* exploreBlue = [UIColor colorWithRed: 0.196f green: 0.325f blue: 0.682f alpha: 1];
    UIColor* casesBlue = [UIColor colorWithRed: 0.106f green: 0.157f blue: 0.333f alpha: 1];
    
    if ([newChild isKindOfClass:[AggregateMapViewController class]]) {
        backgroundColor = casesBlue;
        tabColor = exploreBlue;
    } else {
        backgroundColor = exploreBlue;
        tabColor = casesBlue;
    }

    self.containerBackgroundView.backgroundColor = tabColor;
    self.createReportView.backgroundColor = tabColor;
    self.view.backgroundColor = backgroundColor;
    
    newChild.view.frame = self.containerView.bounds;
    [self.containerView addSubview:newChild.view];
    [self addChildViewController:newChild];
    [newChild didMoveToParentViewController:self];
}

- (IBAction)onTapTabBar:(UITapGestureRecognizer *)sender {
    
    CGPoint location = [sender locationInView:self.exploreTabBar];
    if (location.x > 160) {
        self.exploreTabBar.tabSelected = 1;
        AggregateMapViewController *mapsViewController = self.tabViewControllers[0];
        CaseTableViewController *casesViewController = self.tabViewControllers[1];
        [self show:casesViewController andRemove:mapsViewController];
    } else {
        self.exploreTabBar.tabSelected = 0;
        AggregateMapViewController *mapsViewController = self.tabViewControllers[0];
        CaseTableViewController *casesViewController = self.tabViewControllers[1];
        [self show:mapsViewController andRemove:casesViewController];
    }
}

- (IBAction)onCreateReport:(id)sender {
    NSLog(@"Create new report.");
}
@end
