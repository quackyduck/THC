//
//  ViolationSubmissionViewController.m
//  THC
//
//  Created by Hunaid Hussain on 7/4/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "ViolationSubmissionViewController.h"
#import "ViolationSubmissionForm.h"

@interface ViolationSubmissionViewController ()

@property (strong, nonatomic) NSData    *imageData;
@property (strong, nonatomic) NSString  *violationDescription;

@end

@implementation ViolationSubmissionViewController

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
    
    // Create the FX form controller and specify the form entries
    self.formController = [[FXFormController alloc] init];
    self.formController.tableView = self.tableView;
    self.formController.delegate = self;
    self.formController.form = [[ViolationSubmissionForm alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //reload the table
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submitViolationSubmissionForm:(UITableViewCell<FXFormFieldCell> *)cell
{
    //we can lookup the form from the cell if we want, like this:
    ViolationSubmissionForm *form =  (ViolationSubmissionForm *) cell.field.form;
    [form printFormContents];
    //we can then perform validation, etc
    /*
     if (form.agreedToTerms)
     {
     [[[UIAlertView alloc] initWithTitle:@"Login Form Submitted" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
     }
     else
     {
     [[[UIAlertView alloc] initWithTitle:@"User Error" message:@"Please agree to the terms and conditions before proceeding" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Yes Sir!", nil] show];
     }
     */
    
    [[[UIAlertView alloc] initWithTitle:@"Violation Submitted" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -
#pragma public functions

-(void) setImageData:(NSData *) imageData {
    _imageData = imageData;
}

-(void) setViolationDescription:(NSString *) description {
    _violationDescription = description;
}

@end
