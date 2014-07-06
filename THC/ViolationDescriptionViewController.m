//
//  ViolationDescriptionViewController.m
//  THC
//
//  Created by Hunaid Hussain on 7/6/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "ViolationDescriptionViewController.h"
#import "ViolationSubmissionViewController.h"

@interface ViolationDescriptionViewController ()

@property (weak, nonatomic) IBOutlet UITextView *violLationDescriptionTextView;
@property (strong, nonatomic) UIBarButtonItem *nextButton;


@end

@implementation ViolationDescriptionViewController

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
    [self initializeView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma create view elements
- (void) initializeView {
    
    self.violLationDescriptionTextView.delegate = self;
    
    [self createTitleLabel];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    [cancelButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor blackColor],  NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(onNext)];
    [self.nextButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor blackColor],  NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [self.nextButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor grayColor],  NSForegroundColorAttributeName,nil] forState:UIControlStateDisabled];

    self.nextButton.enabled = NO;
    
    self.navigationItem.rightBarButtonItem = self.nextButton;
    
    //[self.violLationDescriptionTextView performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.8];
    
    return;
}

- (void) createTitleLabel {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"Create Report";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    
    self.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];
}

#pragma keyboard delegates

- (void)textViewDidChange:(UITextView *)textView {
    
    if ([self.violLationDescriptionTextView.text length]) {
        self.nextButton.enabled = YES;
    } else {
        self.nextButton.enabled = NO;
    }
}


- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.violLationDescriptionTextView.text =@"";
    self.violLationDescriptionTextView.textColor = [UIColor blackColor];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.violLationDescriptionTextView resignFirstResponder];
}

- (void) resignViewController:(id)sender {
    
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma  button actions

-(void) onCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) onNext {
    
    ViolationSubmissionViewController * vsc = [[ViolationSubmissionViewController alloc] init];
    [self.navigationController pushViewController:vsc animated:YES];
    
}

@end
