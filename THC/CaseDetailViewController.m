//
//  CaseDetailViewController.m
//  THC
//
//  Created by David Bernthal on 7/5/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "CaseDetailViewController.h"

@interface CaseDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *languageLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *noteTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *testImageView;

@property (strong, nonatomic) Case *currentCase;

- (IBAction)onEdit:(UIButton *)sender;
- (IBAction)onSendNote:(UIButton *)sender;
@end

@implementation CaseDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCase:(Case *)myCase
{
    self = [super initWithNibName:@"CaseDetailViewController" bundle:nil];
    if (self) {
        self.currentCase = myCase;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nameLabel.text = self.currentCase.name;
    self.unitLabel.text = self.currentCase.unit;
    self.languageLabel.text = self.currentCase.languageSpoken;
    self.emailLabel.text = self.currentCase.email;
    self.phoneLabel.text = self.currentCase.phoneNumber;
    self.descriptionLabel.text = self.currentCase.description;
    
    
    //Change this dynamically once notes are working
    [self.scrollView setContentSize:CGSizeMake(320, 724)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onEdit:(UIButton *)sender {
}

- (IBAction)onSendNote:(UIButton *)sender {
}
@end
