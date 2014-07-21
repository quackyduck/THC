//
//  HappySunViewController.m
//  THC
//
//  Created by David Bernthal on 7/20/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "HappySunViewController.h"
#import "LoginViewController.h"
#import "SignupViewController.h"

@interface HappySunViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *happySunImageView;
- (IBAction)onLoginTap:(UITapGestureRecognizer *)sender;
- (IBAction)onGetStartedTap:(UITapGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;

@end

@implementation HappySunViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.happySunImageView setImage:[UIImage imageNamed:@"HappySun"]];
    self.loginLabel.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLoginTap:(UITapGestureRecognizer *)sender {
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    [self presentViewController:loginViewController animated:YES completion:nil];
}

- (IBAction)onGetStartedTap:(UITapGestureRecognizer *)sender {
    SignupViewController *signUpViewController = [[SignupViewController alloc] init];
    [self presentViewController:signUpViewController animated:YES completion:nil];
}

@end




