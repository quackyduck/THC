//
//  ViolationSubmissionViewController.m
//  THC
//
//  Created by Hunaid Hussain on 7/4/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "ViolationSubmissionViewController.h"
#import "ViolationSubmissionForm.h"
#import "CaseDetailViewController.h"
#import "Building.h"
#import <Parse/Parse.h>



@interface ViolationSubmissionViewController ()

@property (strong, nonatomic) NSData    *imageData;
@property (strong, nonatomic) NSString  *violationDescription;
@property (strong, nonatomic) Case      *myCase;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshForm)
                                                 name:@"Addresses Retrieved"
                                               object:nil];
    
    // Create the FX form controller and specify the form entries
    self.formController = [[FXFormController alloc] init];
    self.formController.tableView = self.tableView;
    self.formController.delegate = self;
    if (self.myCase) //This is the edit form
    {
        ViolationSubmissionForm* populatedForm = [[ViolationSubmissionForm alloc] init];
        populatedForm.firstName = self.myCase.name;
        populatedForm.lastName = self.myCase.name;
        populatedForm.unitNum = self.myCase.unit;
        populatedForm.phoneNumber = self.myCase.phoneNumber;
        populatedForm.email = self.myCase.email;
        populatedForm.languagesSpoken = self.myCase.languageSpoken;
        
        PFQuery *query = [Building query];
        [query whereKey:@"objectId" equalTo:self.myCase.buildingId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                if (objects.count > 0)
                {
                    populatedForm.addressForm.hotelName = ((Building*)objects[0]).buildingName;
                } else
                {
                    populatedForm.addressForm.otherAddress.streetName = self.myCase.address;
                }
            }
        }];
        self.formController.form = populatedForm;
    } else
    {
        self.formController.form = [[ViolationSubmissionForm alloc] init];
    }
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

#pragma mark -
#pragma Dynamic Form Changes

- (void)refreshForm {
    self.formController.form = self.formController.form;
    [self.tableView reloadData];
}
- (void)addOtherLanguage:(UITableViewCell<FXFormFieldCell> *)cell {
    ViolationSubmissionForm *form =  (ViolationSubmissionForm *) cell.field.form;
    if ([form.languagesSpoken isEqualToString:@"Other"]) {
        form.showOtherLanguage = YES;
        self.formController.form = self.formController.form;
        [self.tableView reloadData];
    }
}

- (void)changeAddress {
    ViolationSubmissionForm *form =  (ViolationSubmissionForm *) self.formController.form;
    if ([form.addressForm.hotelName isEqualToString:@"Other"]) {
        form.addressForm.showOtherAddress = YES;
        self.formController.form = self.formController.form;
        [self.tableView reloadData];
    }
}

- (void)submitViolationSubmissionForm:(UITableViewCell<FXFormFieldCell> *)cell
{
    //we can lookup the form from the cell if we want, like this:
    ViolationSubmissionForm *form =  (ViolationSubmissionForm *) cell.field.form;
    [form printFormContents];
    if (self.myCase) //case was already created, just update it
    {
        [form updateCase:self.myCase];
        CaseDetailViewController *detailvc = [[CaseDetailViewController alloc] initWithCase:self.myCase isNewCase:NO];
        [self presentViewController:detailvc animated:YES completion:nil];
    } else
    {
        Case* createdCase = [form createCaseWithDescription:self.violationDescription andImageData:self.imageData];
        CaseDetailViewController *detailvc = [[CaseDetailViewController alloc] initWithCase:createdCase isNewCase:YES];
        [self presentViewController:detailvc animated:YES completion:nil];
    }
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
    
//    [[[UIAlertView alloc] initWithTitle:@"Violation Submitted" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
}

#pragma mark -
#pragma public functions

-(void) setImageData:(NSData *) imageData {
    _imageData = imageData;
}

-(void) setViolationDescription:(NSString *) description {
    _violationDescription = description;
}

-(void) setCase:(Case *) myCase {
    _myCase = myCase;
}

@end
