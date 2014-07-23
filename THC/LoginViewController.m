//
//  LoginViewController.m
//  THC
//
//  Created by Nicolas Melo on 7/2/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginButton.h"
#import "RequestAccessButton.h"
#import <Parse/Parse.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet LoginButton *loginButton;
@property (weak, nonatomic) IBOutlet RequestAccessButton *requestAccessButton;

@end

@implementation LoginViewController

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
    // Do any additional setup after loading the view from its nib.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.view.backgroundColor = [UIColor colorWithRed: 1 green: 0.455f blue: 0.184f alpha: 1];
    
    self.loginButton.enabled = NO;

    self.emailTextField.tintColor = [UIColor whiteColor];
    self.emailTextField.delegate = self;
    UIColor *placeHolderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email Address" attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
    
    
    self.passwordTextField.delegate = self;
    self.passwordTextField.tintColor = [UIColor whiteColor];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: placeHolderColor}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogin:(id)sender {
    
    [PFUser logInWithUsernameInBackground:self.emailTextField.text
                                 password:self.passwordTextField.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            NSLog(@"Logged in successfully.");
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                        } else {
                                            // The login failed.
                                            NSLog(@"Error %@", error);
                                        }
                                    }];
}
- (IBAction)onDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onRequestAccess:(id)sender {
    UIAlertView *requestAccessAlert = [[UIAlertView alloc] initWithTitle:@"Request Access" message:@"Your request is being considered" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [requestAccessAlert show];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.passwordTextField) {
    
        NSUInteger length = textField.text.length - range.length + string.length;
        if (length > 0) {
            self.loginButton.enabled = YES;
        } else {
            self.loginButton.enabled = NO;
        }
        
    }
    return YES;
}

@end
