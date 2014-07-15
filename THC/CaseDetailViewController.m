//
//  CaseDetailViewController.m
//  THC
//
//  Created by David Bernthal on 7/5/14.
//  Copyright (c) 2014 THC. All rights reserved.
//

#import "CaseDetailViewController.h"
#import "ViolationSubmissionViewController.h"
#import "PhotoInfo.h"
#import "Note.h"
#import "Building.h"

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
@property (weak, nonatomic) IBOutlet UILabel *testNoteLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;

//Confirmation View Elements
@property (weak, nonatomic) IBOutlet UIImageView *backgroundBuildingImageView;
@property (weak, nonatomic) IBOutlet UIImageView *checkMarkImageView;
@property (weak, nonatomic) IBOutlet UILabel *buildingNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmationHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *confirmationView;

@property (strong, nonatomic) Case *currentCase;
@property (assign) BOOL isNewCase;

- (IBAction)onEdit:(UIButton *)sender;
- (IBAction)onSendNote:(UIButton *)sender;
- (IBAction)onTap:(id)sender;

- (void)willShowKeyboard:(NSNotification *)notification;
- (void)willHideKeyboard:(NSNotification *)notification;

@end

@implementation CaseDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Register the methods for the keyboard hide/show events
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (id)initWithCase:(Case *)myCase isNewCase:(BOOL)newCase
{
    self = [self initWithNibName:@"CaseDetailViewController" bundle:nil];
    if (self) {
        self.currentCase = myCase;
        self.isNewCase = newCase;
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
    
    //Get first note
    PFQuery *noteQuery = [Note query];
    [noteQuery whereKey:@"caseId" equalTo:self.currentCase.caseId];
    [noteQuery orderByDescending:@"createdAt"];
    noteQuery.limit = 1;//For now
    [noteQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0)
            {
                Note* note = objects[0];
                self.testNoteLabel.text = note.text;
            }
        }
    }];
    
    //Get first image to show
    PFQuery *query = [PhotoInfo query];
    [query whereKey:@"caseId" equalTo:self.currentCase.caseId];
    [query orderByAscending:@"createdAt"];
    query.limit = 1;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0)
            {
                PhotoInfo* photoObject = objects[0];
                PFFile *photo = photoObject.image;
                NSData *imageData = [photo getData];
                UIImage *image = [UIImage imageWithData:imageData];
                [self.testImageView setImage:image];
            }
        }
    }];
    
    if (self.isNewCase)
    {
       UIImage* checkImage = [UIImage imageNamed:@"Confirmation"];
       [self.checkMarkImageView setImage:checkImage];
        
        //Get building
//        PFQuery *buildingQuery = [Building query];
//        [buildingQuery whereKey:@"buildingName" equalTo:@"Hotel Union"];
//        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//            if (!error) {
//                if (objects.count > 0)
//                {
//                    self.buildingNameLabel.text = ((Building*)objects[0]).buildingName;
//                    
//                    //Get building photo from Building object??
//                } else
//                {
//                    self.buildingNameLabel.text = self.currentCase.address;
//                    
//                    //Use stock building photo
//                }
//            }
//        }];
    } else
    {
        self.confirmationView.hidden = YES;
        self.confirmationHeightConstraint.constant = 0.0f;
    }
    
    //Change this dynamically once notes are working
    [self.scrollView setContentSize:CGSizeMake(self.contentView.frame.size.width, self.contentView.frame.size.height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willShowKeyboard:(NSNotification *)notification {
    self.noteTextField.text = @"";
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the keyboard height and width from the notification
    // Size varies depending on OS, language, orientation
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSLog(@"Height: %f Width: %f", kbSize.height, kbSize.width);
    
    // Get the animation duration and curve from the notification
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    
    // Move the view with the same duration and animation curve so that it will match with the keyboard animation
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:(animationCurve << 16)
                     animations:^{
                         self.scrollView.frame = CGRectMake(0, self.view.frame.size.height - kbSize.height - self.scrollView.frame.size.height, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
                     }
                     completion:nil];
}

- (void)willHideKeyboard:(NSNotification *)notification {
    self.noteTextField.text = @"Add a note...";
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the animation duration and curve from the notification
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    
    // Move the view with the same duration and animation curve so that it will match with the keyboard animation
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:(animationCurve << 16)
                     animations:^{
                         self.scrollView.frame = CGRectMake(0, self.view.frame.size.height - self.scrollView.frame.size.height, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
                     }
                     completion:nil];
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)onEdit:(UIButton *)sender {
    ViolationSubmissionViewController * vsc = [[ViolationSubmissionViewController alloc] init];
    [vsc setCase:self.currentCase];
    [self presentViewController:vsc animated:YES completion:nil];
}

- (IBAction)onSendNote:(UIButton *)sender {
    Note* note = [Note object];
    note.caseId = self.currentCase.caseId;
    note.text = self.noteTextField.text;;
    [note saveInBackground];
    [self.view endEditing:YES];
}

@end
