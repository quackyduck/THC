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
@property (strong, nonatomic) NSArray *tabViewControllers;

- (IBAction)onShowExploreViewController:(id)sender;
- (IBAction)onShowCasesViewController:(id)sender;
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
    
    if ([newChild isKindOfClass:[AggregateMapViewController class]]) {
        backgroundColor = [UIColor colorWithRed:50/255.0f green:83/255.0f blue:174/255.0f alpha:1.0f];
    } else {
        backgroundColor = [UIColor colorWithRed:27/255.0f green:40/255.0f blue:85/255.0f alpha:1.0f];
    }
    
    self.tabBar.backgroundColor = backgroundColor;
    self.createReportView.backgroundColor = backgroundColor;
    self.view.backgroundColor = backgroundColor;
    
    newChild.view.frame = self.containerView.bounds;
    [self.containerView addSubview:newChild.view];
    [self addChildViewController:newChild];
    [newChild didMoveToParentViewController:self];
}

- (IBAction)onShowExploreViewController:(id)sender {
    
    AggregateMapViewController *mapsViewController = self.tabViewControllers[0];
    CaseTableViewController *casesViewController = self.tabViewControllers[1];
    
    [self show:mapsViewController andRemove:casesViewController];
    
}

- (IBAction)onShowCasesViewController:(id)sender {

    AggregateMapViewController *mapsViewController = self.tabViewControllers[0];
    CaseTableViewController *casesViewController = self.tabViewControllers[1];
    
    [self show:casesViewController andRemove:mapsViewController];
}

- (IBAction)onCreateReport:(id)sender {
    NSLog(@"Create new report.");
}
@end
