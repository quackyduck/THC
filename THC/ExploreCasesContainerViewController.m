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

@interface ExploreCasesContainerViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *createReportView;
@property (weak, nonatomic) IBOutlet UIView *tabBar;
@property (weak, nonatomic) IBOutlet UIButton *createReportButton;
@property (weak, nonatomic) IBOutlet UIButton *exploreTabButton;
@property (weak, nonatomic) IBOutlet UIButton *CasesTabButton;
- (IBAction)onShowExploreViewController:(id)sender;
- (IBAction)onShowCasesViewController:(id)sender;

//@property (strong, nonatomic) AggregateMapViewController *mapViewController;
//@property (strong, nonatomic) CaseTableViewController *caseTableViewController;
@property (strong, nonatomic) NSArray *tabViewControllers;

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
    
    AggregateMapViewController *mapViewController = (AggregateMapViewController *)self.tabViewControllers[0];
    mapViewController.view.frame = self.containerView.bounds;
    [self.containerView addSubview:mapViewController.view];
    [self addChildViewController:mapViewController];
    [mapViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onShowExploreViewController:(id)sender {
    AggregateMapViewController *mapsViewController = self.tabViewControllers[0];
    CaseTableViewController *casesViewController = self.tabViewControllers[1];
    
    [casesViewController.view removeFromSuperview];
    [casesViewController removeFromParentViewController];
    
    mapsViewController.view.frame = self.containerView.bounds;
    [self.containerView addSubview:mapsViewController.view];
    [self addChildViewController:mapsViewController];
    [mapsViewController didMoveToParentViewController:self];
    
}

- (IBAction)onShowCasesViewController:(id)sender {
    AggregateMapViewController *mapsViewController = self.tabViewControllers[0];
    CaseTableViewController *casesViewController = self.tabViewControllers[1];
    
    [mapsViewController.view removeFromSuperview];
    [mapsViewController removeFromParentViewController];
    
    
    casesViewController.view.frame = self.containerView.bounds;
    [self.containerView addSubview:casesViewController.view];
    [self addChildViewController:casesViewController];
    [casesViewController didMoveToParentViewController:self];
}
@end
