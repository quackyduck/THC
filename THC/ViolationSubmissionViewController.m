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
#import "AlbumListController.h"
#import "NameFieldCell.h"
#import "SpokenLanguageFieldCell.h"
#import "PhoneFieldCell.h"
#import "EmailFieldCell.h"
#import "HotelFieldCell.h"
#import "UnitFieldCell.h"
#import "ViolationTypeFieldCell.h"
#import "ViolationDescriptionFieldCell.h"
#import "ViolationForm.h"
#import "MultiUnitFieldCell.h"
#import "SubmitCell.h"


#define greyColor   [UIColor colorWithRed: 0.667f green: 0.667f blue: 0.667f alpha: 0.35f]
#define orangeColor [UIColor colorWithRed: 1 green: 0.455f blue: 0.184f alpha: 1]
#define whiteColor  [UIColor whiteColor]

#define LanguageList  @{@"English", @"Spanish", @"Chinese", @"Mandarin", @"Vietnami", @"Phillipino", nil}
#define AllFields     @[@"name", @"languageSpoken", @"phone", @"email", @"hotel", @"unit", @"violationDescription", @"violationType", @"multiUnitPetition", @"submit"]
#define FieldList     @[@"name", @"languageSpoken", @"phone", @"email"]
#define PersonalInfo  @[@"name", @"languageSpoken", @"phone", @"email"]
#define HotelInfo     @[@"hotel", @"unit"]
#define ViolationInfo @[@"violationType", @"violationDescription", @"multiUnitPetition"]
#define SubmitInfo    @[@"submit"]
//#define FormFields    @{@"0": PersonalInfo, @"1": HotelInfo}
#define FormFields    @{@"0": PersonalInfo, @"1": HotelInfo, @"2": ViolationInfo,  @"3": SubmitInfo}
#define FormSectionHeader    @{@"0": @"Tenant Information", @"1": @"Hotel Information", @"2": @"Violation Details", @"3": @""}



//#define FieldList    @[@"name", @"languageSpoken", @"phone", @"email", @"hotel", @"address",   @"violationDescription"]


@interface ViolationSubmissionViewController ()

@property (strong, nonatomic) NSData                  *imageData;
@property (strong, nonatomic) NSString                *violationDescription;
@property (strong, nonatomic) Case                    *myCase;
@property (strong, nonatomic) NSMutableArray          *imagesInScroll;
@property (strong, nonatomic) NSMutableArray          *deleteImagesInScroll;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (weak, nonatomic) IBOutlet UIScrollView     *scrollView;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (strong, nonatomic) NSArray                 *fields;
@property (strong, nonatomic) NSDictionary            *formFields;
@property (strong, nonatomic) NSDictionary            *formSectionHeader;
@property (strong, nonatomic) UITapGestureRecognizer  *tapGestureRecognizer;
@property (strong, nonatomic) NSIndexPath             *currentIndexPath;
@property (strong, nonatomic) ViolationForm           *violationForm;
@property (assign)            BOOL                    showFilledForm;


@end

@implementation ViolationSubmissionViewController

NameFieldCell                   *_stubNameCell;
SpokenLanguageFieldCell         *_stubLanguageCell;
HotelFieldCell                  *_stubHotelCell;
UnitFieldCell                   *_stubUnitCell;
PhoneFieldCell                  *_stubPhoneCell;
ViolationDescriptionFieldCell   *_stubViolationCell;
ViolationTypeFieldCell          *_stubViolationTypeCell;
EmailFieldCell                  *_stubEmailCell;
MultiUnitFieldCell              *_stubMultiUnitFieldCell;
SubmitCell                      *_stubSubmitCell;

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

- (void)initializeView {
    
    // This commented code blends the navigation bar with the tble view
//    UINavigationBar *navigationBar = self.navigationController.navigationBar;
//    
//    [navigationBar setBackgroundImage:[UIImage new]
//                       forBarPosition:UIBarPositionAny
//                           barMetrics:UIBarMetricsDefault];
//    
//    [navigationBar setShadowImage:[UIImage new]];
    
//    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed: 0.106f green: 0.157f blue: 0.333f alpha: 1];
    self.navigationController.navigationBar.barTintColor = self.tableView.backgroundColor;


//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
//                                                                                           target:self
//                                                                                           action:@selector(cancelButtonAction)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_nav_back_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonAction)];

//    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = orangeColor;
    
//    self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"ic_nav_back_normal@2x"];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
//                                                                                          target:self
//                                                                                          action:@selector(editForm)];
//    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Submit"
                                                                    style:UIBarButtonItemStylePlain
                                                                    target:self action:@selector(submitForm)];
    
//    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshForm)
                                                 name:@"Addresses Retrieved"
                                               object:nil];
    
    // This is old FXForm code
    /*
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

     */
    
    self.fields = AllFields;
    self.formFields = FormFields;
    self.formSectionHeader = FormSectionHeader;
    
    if (!self.violationForm) {
        self.violationForm = [[ViolationForm alloc] init];
        self.showFilledForm = NO;
    }
    
    [self registerFieldCells];
    
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    [self setupKeyboardDismissGestures];
    [self registerForKeyboardNotifications];
    [self.tableView reloadData];
    
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    } else {
        self.picker = [[UIImagePickerController alloc] init];
        self.picker.delegate = self;
        //self.picker.allowsEditing = YES;
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        

//        self.scrollView.backgroundColor = [UIColor colorWithRed: 0.196f green: 0.325f blue: 0.682f alpha: 1];
//        self.scrollView.backgroundColor = [UIColor colorWithRed: 1 green: 0.455f blue: 0.184f alpha: 1];
        self.scrollView.backgroundColor = self.tableView.backgroundColor;


        self.scrollView.delegate = self;
        
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.scrollView addSubview:self.activityView];
        
        CGPoint scrollViewCenter = CGPointMake(self.scrollView.frame.size.width/2, self.scrollView.frame.size.height/2);
        CGPoint activityCenter = [self.view convertPoint:scrollViewCenter fromView:self.scrollView];
        
        self.activityView.center = activityCenter;

        
        //self.pageControl.numberOfPages = 0;
        self.imagesInScroll = [NSMutableArray array];
        self.deleteImagesInScroll = [NSMutableArray array];

        
        CGSize contentSize = CGSizeZero;
        contentSize.width = 80;
        contentSize.height = 80;
        self.scrollView.contentSize = contentSize;
        
        contentSize.width = self.scrollView.frame.size.width;
        contentSize.height = self.scrollView.frame.size.height;
        self.scrollView.contentSize = contentSize;
        
        CGFloat padding = 5.0;
        CGRect imageViewFrame = CGRectInset(self.scrollView.frame, padding, padding);
        imageViewFrame.origin.x =  padding;
        imageViewFrame.origin.y = padding;
        imageViewFrame.size.width = 70;
        imageViewFrame.size.height = 70;
        NSLog(@"scroll view frame %@", NSStringFromCGRect(self.scrollView.frame));

        //NSLog(@"library imageview frame: x: %f y: %f width %f height %f", imageViewFrame.origin.x, imageViewFrame.origin.y, imageViewFrame.size.width, imageViewFrame.size.height);
        
        UIImage *image = [UIImage imageNamed:@"ic_camera_add"];
//        NSLog(@"camera image %@", image);
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//        imageView.backgroundColor = [UIColor blackColor];
        imageView.frame = imageViewFrame;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.layer.cornerRadius = 4.f;
        imageView.layer.borderWidth = 1.f;
        
//        imageView.backgroundColor = [UIColor colorWithRed: 0.196f green: 0.325f blue: 0.682f alpha: 1];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
        [imageView setClipsToBounds:YES];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(launchPhotoPicker:)];
        tap.numberOfTapsRequired = 1;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
        
        imageView.tag = 10000;
        
        [self.scrollView addSubview:imageView];        
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGPoint scrollViewCenter = CGPointMake(self.scrollView.frame.size.width/2, self.scrollView.frame.size.height/2);
    CGPoint activityCenter = [self.view convertPoint:scrollViewCenter fromView:self.scrollView];
    
    self.activityView.center = activityCenter;
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

#pragma Public Functions

-(void) setPrefilledForm:(ViolationForm *) form {
    NSLog(@"using prefilled form");
    self.showFilledForm = YES;
    self.violationForm = form;
}

#pragma Register Field Cells

- (void)registerFieldCells {
    
    for (NSString *fieldName in self.fields) {
        
        if ([fieldName isEqualToString:@"name"]) {
            UINib *cellNib = [UINib nibWithNibName:@"NameFieldCell" bundle:nil];
            [self.tableView registerNib:cellNib forCellReuseIdentifier:@"NameFieldCell"];
            _stubNameCell = [cellNib instantiateWithOwner:nil options:nil][0];
        } else if ([fieldName isEqualToString:@"languageSpoken"]) {
            UINib *cellNib = [UINib nibWithNibName:@"SpokenLanguageFieldCell" bundle:nil];
            [self.tableView registerNib:cellNib forCellReuseIdentifier:@"LanguageCell"];
            _stubLanguageCell = [cellNib instantiateWithOwner:nil options:nil][0];
        } else if ([fieldName isEqualToString:@"hotel"]) {
            UINib *cellNib = [UINib nibWithNibName:@"HotelFieldCell" bundle:nil];
            [self.tableView registerNib:cellNib forCellReuseIdentifier:@"HotelMenuCell"];
            _stubHotelCell = [cellNib instantiateWithOwner:nil options:nil][0];
        } else if ([fieldName isEqualToString:@"email"]) {
            UINib *cellNib = [UINib nibWithNibName:@"EmailFieldCell" bundle:nil];
            [self.tableView registerNib:cellNib forCellReuseIdentifier:@"EmailFieldCell"];
            _stubEmailCell = [cellNib instantiateWithOwner:nil options:nil][0];
        } else if ([fieldName isEqualToString:@"phone"]) {
            UINib *cellNib = [UINib nibWithNibName:@"PhoneFieldCell" bundle:nil];
            [self.tableView registerNib:cellNib forCellReuseIdentifier:@"PhoneCell"];
            _stubPhoneCell = [cellNib instantiateWithOwner:nil options:nil][0];
        } else if ([fieldName isEqualToString:@"hotel"]) {
            UINib *cellNib = [UINib nibWithNibName:@"HotelFieldCell" bundle:nil];
            [self.tableView registerNib:cellNib forCellReuseIdentifier:@"HotelFieldCell"];
            _stubHotelCell = [cellNib instantiateWithOwner:nil options:nil][0];
        } else if ([fieldName isEqualToString:@"unit"]) {
            UINib *cellNib = [UINib nibWithNibName:@"UnitFieldCell" bundle:nil];
            [self.tableView registerNib:cellNib forCellReuseIdentifier:@"UnitFieldCell"];
            _stubUnitCell = [cellNib instantiateWithOwner:nil options:nil][0];
        } else if ([fieldName isEqualToString:@"violationDescription"]) {
            UINib *cellNib = [UINib nibWithNibName:@"ViolationDescriptionFieldCell" bundle:nil];
            [self.tableView registerNib:cellNib forCellReuseIdentifier:@"ViolationCell"];
            _stubViolationCell = [cellNib instantiateWithOwner:nil options:nil][0];
        } else if ([fieldName isEqualToString:@"violationType"]) {
            UINib *cellNib = [UINib nibWithNibName:@"ViolationTypeFieldCell" bundle:nil];
            [self.tableView registerNib:cellNib forCellReuseIdentifier:@"ViolationTypeFieldCell"];
            _stubViolationTypeCell = [cellNib instantiateWithOwner:nil options:nil][0];
        } else if ([fieldName isEqualToString:@"multiUnitPetition"]) {
            UINib *cellNib = [UINib nibWithNibName:@"MultiUnitFieldCell" bundle:nil];
            [self.tableView registerNib:cellNib forCellReuseIdentifier:@"MultiUnitFieldCell"];
            _stubMultiUnitFieldCell = [cellNib instantiateWithOwner:nil options:nil][0];
        } else if ([fieldName isEqualToString:@"submit"]) {
            UINib *cellNib = [UINib nibWithNibName:@"SubmitCell" bundle:nil];
            [self.tableView registerNib:cellNib forCellReuseIdentifier:@"SubmitCell"];
            _stubSubmitCell = [cellNib instantiateWithOwner:nil options:nil][0];
        }
    }
}

#pragma mark -
#pragma Keyboard notification setup

- (void)setupKeyboardDismissGestures
{
    
    //    Example for a swipe gesture recognizer. it was not set-up since we use scrollViewDelegate for dissmin-on-swiping, but it could be useful to keep in mind for views that do not inherit from UIScrollView
    //    UISwipeGestureRecognizer *swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    //    swipeUpGestureRecognizer.cancelsTouchesInView = NO;
    //    swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    //    [self.tableView addGestureRecognizer:swipeUpGestureRecognizer];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    //this prevents the gestureRecognizer to override other Taps, such as Cell Selection
    self.tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:self.tapGestureRecognizer];
    
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSLog(@"keyboard shown, scrolling up");
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    NSLog(@"contentInset %@", NSStringFromUIEdgeInsets(self.tableView.contentInset));
    
    CGRect kboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //    self.tableView.contentInset = contentInsets;
    //    scrollView.scrollIndicatorInsets = contentInsets;
    
    
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.currentIndexPath];
    
    CGRect aRect = cell.frame;
    
    CGRect rectOfCellInTableView = [self.tableView rectForRowAtIndexPath:self.currentIndexPath];
    CGRect rectOfCellInSuperview = [self.tableView convertRect:rectOfCellInTableView toView:[self.tableView superview]];
    
    //    CGRect aRect = rectOfCellInSuperview;
    NSLog(@"cell frame at row %d %@", self.currentIndexPath.row, NSStringFromCGRect(rectOfCellInSuperview));
    NSLog(@"kboard frame %@", NSStringFromCGRect(kboardRect));
    
    
    //    aRect.size.height -= kbSize.height;
    if (CGRectIntersectsRect(kboardRect, aRect) ) {
        //        [self.scrollView scrollRectToVisible:activeField.frame animated:YES];
        NSLog(@"table row would move upwards");
        self.tableView.contentInset = contentInsets;
        [self.tableView scrollToRowAtIndexPath:self.currentIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSLog(@"keyboard hidden");
    self.tableView.contentInset = UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height, 0.0, 0.0, 0.0);
}

-(void)hideKeyboard
{
    //this convenience method on UITableView sends a nested message to all subviews, and they resign responders if they have hold of the keyboard
    [self.tableView endEditing:YES];
    
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideKeyboard];
}

#pragma TableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.formFields count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    NSLog(@"num of rows %d", self.fields.count);
    NSArray *sectionContent = [self.formFields objectForKey:[NSString stringWithFormat:@"%ld", (long)section]];
    
    NSLog(@"num of rows %lu", (unsigned long)sectionContent.count);
    
    return [sectionContent count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.formSectionHeader objectForKey:[NSString stringWithFormat:@"%ld", (long)section]];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionContent = [self.formFields objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.section]];

    NSString *fieldName = [sectionContent objectAtIndex:indexPath.row];
    
    if ([fieldName isEqualToString:@"name"]) {
        NameFieldCell *nameCell = (NameFieldCell *)cell;
        nameCell.nameTextField.text = @"Testing";
    } else if ([fieldName isEqualToString:@"languageSpoken"]) {
        SpokenLanguageFieldCell *lanCell = (SpokenLanguageFieldCell *)cell;
        lanCell.languageLabel.text = @"Testing";
    } else if ([fieldName isEqualToString:@"hotel"]) {
        HotelFieldCell *hotelCell = (HotelFieldCell *)cell;
        hotelCell.textLabel.text = @"Testing";
    } else if ([fieldName isEqualToString:@"email"]) {
        EmailFieldCell *emailCell = (EmailFieldCell *)cell;
        emailCell.emailTextField.text = @"Testing";
    } else if ([fieldName isEqualToString:@"phone"]) {
        PhoneFieldCell *phoneCell = (PhoneFieldCell *)cell;
        phoneCell.phoneTextField.text = @"Testing";
    } else if ([fieldName isEqualToString:@"hotel"]) {
        HotelFieldCell *hotelCell = (HotelFieldCell *)cell;
        hotelCell.hotelLabel.text = @"Testing";
    } else if ([fieldName isEqualToString:@"unit"]) {
        UnitFieldCell *unitCell = (UnitFieldCell *)cell;
        unitCell.unitTextField.text = @"Testing";
    } else if ([fieldName isEqualToString:@"violationDescription"]) {
        ViolationDescriptionFieldCell *violationCell = (ViolationDescriptionFieldCell *)cell;
        violationCell.violationDescriptionTextField.text = @"Testing Testing Testing Testing Testing Testing Testing Testing Testing Testing Testing TestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTesting";
    } else if ([fieldName isEqualToString:@"violationType"]) {
        ViolationTypeFieldCell *violationTypeCell = (ViolationTypeFieldCell *)cell;
        violationTypeCell.violationTypeTextField.text = @"Testing";
    } else if ([fieldName isEqualToString:@"multiUnitPetition"]) {
        MultiUnitFieldCell *multiUniteCell = (MultiUnitFieldCell *)cell;
        multiUniteCell.multiUnitField.text = @"Testing";
    } else if ([fieldName isEqualToString:@"submit"]) {
        SubmitCell *multiUniteCell = (SubmitCell *)cell;
//        multiUniteCell.multiUnitField.text = @"Testing";
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *sectionContent = [self.formFields objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.section]];

    NSString *fieldName = [sectionContent objectAtIndex:indexPath.row];
    
    CGFloat height = 0;
    
    if ([fieldName isEqualToString:@"name"]) {
        [self configureCell:_stubNameCell atIndexPath:indexPath];
        [_stubNameCell layoutSubviews];
        height = [_stubNameCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
              height = 45;
    } else if ([fieldName isEqualToString:@"languageSpoken"]) {
        [self configureCell:_stubLanguageCell atIndexPath:indexPath];
        [_stubLanguageCell layoutSubviews];
        [_stubLanguageCell layoutSubviews];
        height = [_stubLanguageCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        height = 45;
    } else if ([fieldName isEqualToString:@"hotel"]) {
        [self configureCell:_stubHotelCell atIndexPath:indexPath];
        [_stubHotelCell layoutSubviews];
        [_stubHotelCell layoutSubviews];
        height = [_stubHotelCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        height = 45;
    } else if ([fieldName isEqualToString:@"email"]) {
        [self configureCell:_stubEmailCell atIndexPath:indexPath];
        //        NSLog(@"_stubEmailCell %@", _stubEmailCell);
        [_stubEmailCell layoutSubviews];
        height = [_stubEmailCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        height = 45;
    } else if ([fieldName isEqualToString:@"phone"]) {
        [self configureCell:_stubPhoneCell atIndexPath:indexPath];
        //        NSLog(@"_stubPhoneCell %@", _stubPhoneCell);
        [_stubPhoneCell layoutSubviews];
        height = 45;
        height = [_stubPhoneCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    } else if ([fieldName isEqualToString:@"hotel"]) {
        [self configureCell:_stubHotelCell atIndexPath:indexPath];
        //        NSLog(@"_stubPhoneCell %@", _stubPhoneCell);
        [_stubHotelCell layoutSubviews];
        height = [_stubPhoneCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    } else if ([fieldName isEqualToString:@"unit"]) {
        [self configureCell:_stubUnitCell atIndexPath:indexPath];
        //        NSLog(@"_stubPhoneCell %@", _stubPhoneCell);
        [_stubUnitCell layoutSubviews];
        height = [_stubPhoneCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        height = 45;
    } else if ([fieldName isEqualToString:@"violationDescription"]) {
        [self configureCell:_stubViolationCell atIndexPath:indexPath];
//        NSLog(@"_stubViolationCell %@", _stubViolationCell);
        [_stubViolationCell layoutSubviews];
        height = [_stubViolationCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        height = 59;

    } else if ([fieldName isEqualToString:@"violationType"]) {
        [self configureCell:_stubViolationTypeCell atIndexPath:indexPath];
//        NSLog(@"_stubViolationTypeCell %@", _stubViolationTypeCell);
        [_stubViolationTypeCell layoutSubviews];
        height = [_stubViolationTypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        height = 45;
    } else if ([fieldName isEqualToString:@"multiUnitPetition"]) {
        [self configureCell:_stubMultiUnitFieldCell atIndexPath:indexPath];
        //        NSLog(@"_stubViolationTypeCell %@", _stubViolationTypeCell);
        [_stubMultiUnitFieldCell layoutSubviews];
        height = [_stubMultiUnitFieldCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        height = 45;
    } else if ([fieldName isEqualToString:@"submit"]) {
        [self configureCell:_stubSubmitCell atIndexPath:indexPath];
        //        NSLog(@"_stubViolationTypeCell %@", _stubViolationTypeCell);
        [_stubSubmitCell layoutSubviews];
        height = [_stubSubmitCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        height = 59;
    }
    
    NSLog(@"hieght for cell at section %ld row %ld ------> %f  %@", (long)indexPath.section, (long)indexPath.row, height+1, fieldName);
    
    
    return height + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSArray *sectionContent = [self.formFields objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.section]];

    NSString *fieldName = [sectionContent objectAtIndex:indexPath.row];
    
    NSLog(@"creating row for cell %@", fieldName);
    if ([fieldName isEqualToString:@"name"]) {
        NameFieldCell *cell = [ tableView dequeueReusableCellWithIdentifier:@"NameFieldCell" ];
        cell.delegate = self.violationForm;
        if (self.showFilledForm) {
            NSLog(@"asking name to get it from form");
            [cell getFieldValueFromform];
        }
        NSLog(@"creating row for cell %@", fieldName);
        return cell;
    } else if ([fieldName isEqualToString:@"languageSpoken"]) {
        SpokenLanguageFieldCell *cell = [ tableView dequeueReusableCellWithIdentifier:@"LanguageCell" ];
        cell.delegate = self.violationForm;
        if (self.showFilledForm) {
            [cell getFieldValueFromform];
        }
        return cell;
    } else if ([fieldName isEqualToString:@"hotel"]) {
        //        HotelCell *cell = [ tableView dequeueReusableCellWithIdentifier:@"HotelCell" ];
        HotelFieldCell *cell = [ tableView dequeueReusableCellWithIdentifier:@"HotelMenuCell" ];
        cell.delegate = self.violationForm;
        if (self.showFilledForm) {
            [cell getFieldValueFromform];
        }
        return cell;
    } else if ([fieldName isEqualToString:@"email"]) {
        EmailFieldCell *cell = [ tableView dequeueReusableCellWithIdentifier:@"EmailFieldCell" ];
        cell.delegate = self.violationForm;
        if (self.showFilledForm) {
            [cell getFieldValueFromform];
        }
        return cell;
    } else if ([fieldName isEqualToString:@"phone"]) {
        PhoneFieldCell *cell = [ tableView dequeueReusableCellWithIdentifier:@"PhoneCell" ];
        cell.delegate = self.violationForm;
        if (self.showFilledForm) {
            [cell getFieldValueFromform];
        }
        return cell;
    } else if ([fieldName isEqualToString:@"hotel"]) {
        HotelFieldCell *cell = [ tableView dequeueReusableCellWithIdentifier:@"HotelFieldCell" ];
        cell.delegate = self.violationForm;
        if (self.showFilledForm) {
            [cell getFieldValueFromform];
        }
        return cell;
    } else if ([fieldName isEqualToString:@"unit"]) {
        UnitFieldCell *cell = [ tableView dequeueReusableCellWithIdentifier:@"UnitFieldCell" ];
        cell.delegate = self.violationForm;
        if (self.showFilledForm) {
            [cell getFieldValueFromform];
        }
        return cell;
    } else if ([fieldName isEqualToString:@"violationDescription"]) {
        ViolationDescriptionFieldCell *cell = [ tableView dequeueReusableCellWithIdentifier:@"ViolationCell" ];
        cell.delegate = self.violationForm;
        if (self.showFilledForm) {
            [cell getFieldValueFromform];
        }
        return cell;
    } else if ([fieldName isEqualToString:@"violationType"]) {
        ViolationDescriptionFieldCell *cell = [ tableView dequeueReusableCellWithIdentifier:@"ViolationTypeFieldCell" ];
        cell.delegate = self.violationForm;
        if (self.showFilledForm) {
            [cell getFieldValueFromform];
        }
        return cell;
    } else if ([fieldName isEqualToString:@"multiUnitPetition"]) {
        MultiUnitFieldCell *cell = [ tableView dequeueReusableCellWithIdentifier:@"MultiUnitFieldCell" ];
        cell.delegate = self.violationForm;
        if (self.showFilledForm) {
            [cell getFieldValueFromform];
        }
        return cell;
    } else if ([fieldName isEqualToString:@"submit"]) {
        SubmitCell *cell = [ tableView dequeueReusableCellWithIdentifier:@"SubmitCell" ];
        cell.delegate = self.violationForm;
        return cell;
    }
    
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[self tableView] endEditing:YES];
    
    self.currentIndexPath = indexPath;
    NSLog(@"current index path: %ld", (long)self.currentIndexPath.row);
    
    NSArray *sectionContent = [self.formFields objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.section]];

    NSString *fieldName  = [sectionContent objectAtIndex:indexPath.row];
    if ([fieldName isEqualToString:@"languageSpoken"]) {
        [self.tapGestureRecognizer setEnabled:NO];
        CGRect rectOfCellInTableView = [tableView rectForRowAtIndexPath:indexPath];
        CGRect rectOfCellInSuperview = [tableView convertRect:rectOfCellInTableView toView:[tableView superview]];
        NSLog(@"rect of Spoken language cell in superview %@", NSStringFromCGRect(rectOfCellInSuperview));
        NSLog(@"rect of Spoken language cell in tableview %@", NSStringFromCGRect(rectOfCellInTableView));
        
        
        if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
            NSLog(@"portrait orientation");
        }
        SpokenLanguageFieldCell *cell = (SpokenLanguageFieldCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell showMenu:rectOfCellInSuperview onView:self.tableView forOrientation:self.interfaceOrientation];
    } else    if ([fieldName isEqualToString:@"hotel"]) {
        [self.tapGestureRecognizer setEnabled:NO];
        CGRect rectOfCellInTableView = [tableView rectForRowAtIndexPath:indexPath];
        CGRect rectOfCellInSuperview = [tableView convertRect:rectOfCellInTableView toView:[tableView superview]];
        NSLog(@"rect of Spoken language cell in superview %@", NSStringFromCGRect(rectOfCellInSuperview));
        NSLog(@"rect of Spoken language cell in tableview %@", NSStringFromCGRect(rectOfCellInTableView));
        
        
        if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
            NSLog(@"portrait orientation");
        }
        HotelFieldCell *cell = (HotelFieldCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell showMenu:rectOfCellInSuperview onView:self.tableView forOrientation:self.interfaceOrientation];
    } else    if ([fieldName isEqualToString:@"violationType"]) {
        [self.tapGestureRecognizer setEnabled:NO];
        CGRect rectOfCellInTableView = [tableView rectForRowAtIndexPath:indexPath];
        CGRect rectOfCellInSuperview = [tableView convertRect:rectOfCellInTableView toView:[tableView superview]];
        NSLog(@"rect of Spoken language cell in superview %@", NSStringFromCGRect(rectOfCellInSuperview));
        NSLog(@"rect of Spoken language cell in tableview %@", NSStringFromCGRect(rectOfCellInTableView));
        
        
        if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
            NSLog(@"portrait orientation");
        }
        ViolationTypeFieldCell *cell = (ViolationTypeFieldCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell showMenu:rectOfCellInSuperview onView:self.tableView forOrientation:self.interfaceOrientation];
    } else    if ([fieldName isEqualToString:@"multiUnitPetition"]) {
        [self.tapGestureRecognizer setEnabled:NO];
        CGRect rectOfCellInTableView = [tableView rectForRowAtIndexPath:indexPath];
        CGRect rectOfCellInSuperview = [tableView convertRect:rectOfCellInTableView toView:[tableView superview]];
        NSLog(@"rect of Spoken language cell in superview %@", NSStringFromCGRect(rectOfCellInSuperview));
        NSLog(@"rect of Spoken language cell in tableview %@", NSStringFromCGRect(rectOfCellInTableView));
        
        
        if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
            NSLog(@"portrait orientation");
        }
        MultiUnitFieldCell *cell = (MultiUnitFieldCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell showMenu:rectOfCellInSuperview onView:self.tableView forOrientation:self.interfaceOrientation];
    } else if ([fieldName isEqualToString:@"name"]) {
        NameFieldCell *cell = (NameFieldCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.nameTextField.userInteractionEnabled = YES;
        [cell.nameTextField becomeFirstResponder];
    } else if ([fieldName isEqualToString:@"email"]) {
        EmailFieldCell *cell = (EmailFieldCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.emailTextField.userInteractionEnabled = YES;
        [cell.emailTextField becomeFirstResponder];
    } else if ([fieldName isEqualToString:@"phone"]) {
        PhoneFieldCell *cell = (PhoneFieldCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.phoneTextField.userInteractionEnabled = YES;
        [cell.phoneTextField becomeFirstResponder];
    }  else if ([fieldName isEqualToString:@"unit"]) {
        UnitFieldCell *cell = (UnitFieldCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.unitTextField.userInteractionEnabled = YES;
        [cell.unitTextField becomeFirstResponder];
    } else if ([fieldName isEqualToString:@"violationDescription"]) {
        NSLog(@"selecting violation description cell");
        ViolationDescriptionFieldCell *cell = (ViolationDescriptionFieldCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.violationDescriptionTextField.userInteractionEnabled = YES;
        [cell.violationDescriptionTextField becomeFirstResponder];
    }  else if ([fieldName isEqualToString:@"submit"]) {
        SubmitCell *cell = (SubmitCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.submitButton.userInteractionEnabled = YES;
        [cell.submitButton becomeFirstResponder];
    } else {
        [self.tapGestureRecognizer setEnabled:YES];
    }
    
    [tableView  deselectRowAtIndexPath:indexPath  animated:YES];

 
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
//        CaseDetailViewController *detailvc = [[CaseDetailViewController alloc] initWithCase:self.myCase isNewCase:NO];
        [self.navigationController popViewControllerAnimated:YES];
    } else
    {
        NSMutableArray *imageDataList = nil;

        if ([self.imagesInScroll count]) {
            imageDataList = [NSMutableArray array];
            for (UIImageView *imageView in self.imagesInScroll) {
                NSData  *imageData = UIImageJPEGRepresentation(imageView.image, 0);
                [imageDataList addObject:imageData];
            }
        }
        [form createCaseWithDescription:self.violationDescription withImageDataList:imageDataList completion:^(Case* createdCase){
            CaseDetailViewController *detailvc = [[CaseDetailViewController alloc] initWithCase:createdCase isNewCase:YES];
            [self presentViewController:detailvc animated:YES completion:nil];
        } error:^(NSError * onError) {
            NSLog(@"Error creating Case!");
        }];
        
//        [form createCaseWithDescription:self.violationDescription andImageData:self.imageData completion:^(Case* createdCase){
//            CaseDetailViewController *detailvc = [[CaseDetailViewController alloc] initWithCase:createdCase isNewCase:YES];
//            [self presentViewController:detailvc animated:YES completion:nil];
//        } error:^(NSError * onError) {
//            NSLog(@"Error creating Case!");
//        }];
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

- (void)submitForm {
    [self.violationForm dumpFormContent];
    
    NSMutableArray *imageDataList = nil;
    
    if ([self.imagesInScroll count]) {
        imageDataList = [NSMutableArray array];
        for (UIImageView *imageView in self.imagesInScroll) {
            NSData  *imageData = UIImageJPEGRepresentation(imageView.image, 0);
            [imageDataList addObject:imageData];
        }
    }
    [self.violationForm createCaseWithDescription:self.violationDescription withImageDataList:imageDataList completion:^(Case* createdCase){
        CaseDetailViewController *detailvc = [[CaseDetailViewController alloc] initWithCase:createdCase isNewCase:YES];
        [self presentViewController:detailvc animated:YES completion:nil];
    } error:^(NSError * onError) {
        NSLog(@"Error creating Case!");
    }];

}

#pragma ImagePicker Delegate Protocols
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    CGFloat padding = 10.0;
    CGRect imageViewFrame = CGRectInset(self.scrollView.bounds, padding, padding);
    imageViewFrame.origin.x = self.scrollView.frame.size.width + padding;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:chosenImage];
    imageView.frame = imageViewFrame;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:imageView];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    //self.nextButton.enabled = YES;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma custom picker delegate
- (void) finishedPhotoPicker:(UIViewController *)picker withUserSelectedAssets:(NSArray *)assets {
    
    NSLog(@"userSelectedAssets %@", assets);
    
    //[self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //[self.scrollView.subviews removeFromSuperview];
    for (UIView *view in self.scrollView.subviews) {
        if (view.tag != 10000) {
            [view removeFromSuperview];
        }
    }
    [self.scrollView addSubview:self.activityView];




    self.scrollView.contentSize = CGSizeZero;
//    self.pageControl.numberOfPages = 0;
//    self.pageControl.currentPage = 0;
//    self.pageControl.hidden = YES;
    
    //NSLog(@"activity view %@", self.activityView);
    // Show some activity.
    [self.activityView startAnimating];
    
    // Dismiss the picker controller.
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (assets.count == 0) {
            [self.activityView stopAnimating];
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        
        //self.imageView.image = nil;
        
        // ScrollView setup.
        CGFloat padding = 5.0;
        CGFloat width   = 70.0;

        CGSize contentSize = CGSizeZero;
//        contentSize.width = self.scrollView.frame.size.width * assets.count;
        contentSize.width = (width + padding) * (assets.count + 1);

        contentSize.height = self.scrollView.frame.size.height;
        self.scrollView.contentSize = contentSize;
        
        // PageControl setup.
//        self.pageControl.hidden = NO;
//        self.pageControl.numberOfPages = assets.count;
        
        int index = 1;
        
        
        [self.imagesInScroll removeAllObjects];
        for (ALAsset *asset in assets) {
            

//            NSLog(@"scroll view frame %@", NSStringFromCGRect(self.scrollView.bounds));

            CGRect imageViewFrame = CGRectInset(self.scrollView.bounds, padding, padding);
            NSLog(@"image view frame %@", NSStringFromCGRect(imageViewFrame));

            imageViewFrame.size.width = width;
            imageViewFrame.size.height = width;
            imageViewFrame.origin.x = (width + padding) * index + padding;
//            NSLog(@"library imageview frame: x: %f y: %f width %f height %f", imageViewFrame.origin.x, imageViewFrame.origin.y, imageViewFrame.size.width, imageViewFrame.size.height);
            
            //            UIImage *image = [[UIImage alloc] initWithCGImage:asset.defaultRepresentation.fullScreenImage];
            UIImage *image = [[UIImage alloc] initWithCGImage:asset.thumbnail];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = imageViewFrame;
            //imageView.contentMode = UIViewContentModeCenter;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.layer.cornerRadius = 4.f;
            imageView.layer.borderWidth = 1.f;
            
            imageView.backgroundColor = [UIColor colorWithRed: 0.196f green: 0.325f blue: 0.682f alpha: 1];
            imageView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
            [imageView setClipsToBounds:YES];


            CGRect deleteFrame = CGRectInset(imageView.frame, padding, padding);
            deleteFrame.origin.x += width - 4*padding;
            deleteFrame.origin.y -= 2*padding;
            deleteFrame.size.height = 4*padding;
            deleteFrame.size.width  = 4*padding;
            UIImageView *deleteImageView = [self createEditForImageOnFrame:deleteFrame];
//            NSLog(@"delete view frame %@", NSStringFromCGRect(deleteImageView.frame));
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteImage:)];
            tap.numberOfTapsRequired = 1;

            [deleteImageView addGestureRecognizer:tap];
            deleteImageView.userInteractionEnabled = YES;
            deleteImageView.tag = [self.imagesInScroll count];
            
            index++;
            
            
            [self.scrollView addSubview:imageView];

            [self.scrollView addSubview:deleteImageView];
            [self.imagesInScroll addObject:imageView];
            [self.deleteImagesInScroll addObject:deleteImageView];
            
        }
        
        [self.activityView stopAnimating];
        
        [self.scrollView flashScrollIndicators];
    }];
    
}

- (void) finishedPhotoPicker:(UIViewController *)picker withCameraTakenImages:(NSArray *)selectedImages {
    
    //[self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.scrollView.contentSize = CGSizeZero;
//    self.pageControl.numberOfPages = 0;
//    self.pageControl.currentPage = 0;
//    self.pageControl.hidden = YES;
    
//    NSLog(@"activity view %@", self.activityView);
    // Show some activity.
    
    
    for (UIView *view in self.scrollView.subviews) {
        if (view.tag != 10000) {
            [view removeFromSuperview];
        }
    }
    
    [self.scrollView addSubview:self.activityView];

    [self.activityView startAnimating];
    
    // Dismiss the picker controller.
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (selectedImages.count == 0) {
            [self.activityView stopAnimating];
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        
        // ScrollView setup.
        CGFloat padding = 5.0;
        CGFloat width   = 70.0;
        
        CGSize contentSize = CGSizeZero;
        //        contentSize.width = self.scrollView.frame.size.width * assets.count;
        contentSize.width = (width + padding) * (selectedImages.count + 1);
        
        contentSize.height = self.scrollView.frame.size.height;
        self.scrollView.contentSize = contentSize;
        
//        // PageControl setup.
//        self.pageControl.hidden = NO;
//        self.pageControl.numberOfPages = selectedImages.count;
        
        int index = 1;
        
        [self.imagesInScroll removeAllObjects];
        
        for (UIImage *image in selectedImages) {
            
            CGRect imageViewFrame = CGRectInset(self.scrollView.bounds, padding, padding);
            imageViewFrame.size.width = width;
            imageViewFrame.size.height = width;
            imageViewFrame.origin.x = (width + padding) * index + padding;
//            NSLog(@"library imageview frame: x: %f y: %f width %f height %f", imageViewFrame.origin.x, imageViewFrame.origin.y, imageViewFrame.size.width, imageViewFrame.size.height);
            
            //            UIImage *image = [[UIImage alloc] initWithCGImage:asset.defaultRepresentation.fullScreenImage];
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = imageViewFrame;
            //imageView.contentMode = UIViewContentModeCenter;
            //imageView.contentMode = UIViewContentModeCenter;
            imageView.layer.cornerRadius = 4.f;
            imageView.layer.borderWidth = 1.f;
            
            imageView.backgroundColor = [UIColor colorWithRed: 0.196f green: 0.325f blue: 0.682f alpha: 1];
            imageView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
            [imageView setClipsToBounds:YES];
            
            CGRect deleteFrame = CGRectInset(imageView.frame, padding, padding);
            deleteFrame.origin.x += width - 4*padding;
            deleteFrame.origin.y -= 2*padding;
            deleteFrame.size.height = 4*padding;
            deleteFrame.size.width  = 4*padding;
            UIImageView *deleteImageView = [self createEditForImageOnFrame:deleteFrame];
//            NSLog(@"delete view frame %@", NSStringFromCGRect(deleteImageView.frame));
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteImage:)];
            tap.numberOfTapsRequired = 1;
            
            [deleteImageView addGestureRecognizer:tap];
            deleteImageView.userInteractionEnabled = YES;
            deleteImageView.tag = [self.imagesInScroll count];
            
            index++;
            
            [self.scrollView addSubview:imageView];
            [self.scrollView addSubview:deleteImageView];
            [self.imagesInScroll addObject:imageView];
            [self.deleteImagesInScroll addObject:deleteImageView];

            
        }
        
        [self.activityView stopAnimating];
        
        [self.scrollView flashScrollIndicators];
    }];
    
}

- (void)cancelPhotoPicker:(UIViewController *) picker {
 
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"page control current page: %ld", (long)self.pageControl.currentPage);
//    
//    // Update the pageControl > 50% of the previous/next page is visible.
//    CGFloat pageWidth = self.scrollView.frame.size.width;
//    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//    self.pageControl.currentPage = page;
//
//    
//    NSLog(@"page control final page: %d", page);
}

#pragma mark - button actions

- (void)launchPhotoPicker:(UITapGestureRecognizer *) tap {
    NSLog(@"launch photo picker");
    AlbumListController *alc = [[AlbumListController alloc] init];
    alc.delegate = self;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:alc];
    [self presentViewController:nvc animated:YES completion:NULL];
}

- (void)cancelButtonAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)editForm {
    NSLog(@"To edit Form");
}

- (void)deleteImage:(UITapGestureRecognizer *) tap {
//    NSLog(@"Deleteting image with tag %ld", (long)tap.view.tag);
    //UIView *view = tap.view;
//    CGPoint touchLocation = [tap locationInView:tap.view];
    
    

    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        UIImageView *imageView = (UIImageView *)[self.imagesInScroll objectAtIndex:tap.view.tag];
        CGRect frame = imageView.frame;
        CGRect nextFrame;
        [imageView removeFromSuperview];
        [self.imagesInScroll removeObjectAtIndex:tap.view.tag];
        
        CGRect deleteImageFrame = tap.view.frame;
        CGRect nextDeleteImageFrame;
//        NSLog(@"1. deleteImagesInScroll count %lu", (unsigned long)[self.deleteImagesInScroll count]);
        [self.deleteImagesInScroll removeObjectAtIndex:tap.view.tag];
//        NSLog(@"2. deleteImagesInScroll count %lu", (unsigned long)[self.deleteImagesInScroll count]);

        tap.view.alpha = 0;
        //[tap.view removeFromSuperview];
        
        //    int index = 0;
//        BOOL removedLastDeleteImage = NO;
//        if (!removedLastDeleteImage) {
//            UIImageView *lastDeleteImageView = [self.deleteImagesInScroll lastObject];
//            [self.deleteImagesInScroll removeLastObject];
//            [lastDeleteImageView removeFromSuperview];
//            removedLastDeleteImage = YES;
//        }
        
        // Move the remaiing images up.
        
        //    for (UIImageView *iv in self.imagesInScroll) {
        for (NSUInteger i=tap.view.tag; i<[self.imagesInScroll count]; i++) {
            
            UIImageView *iv = [self.imagesInScroll objectAtIndex:i];
            nextFrame = iv.frame;
            iv.frame = frame;
            frame = nextFrame;
            
            UIImageView *deleteImageView = [self.deleteImagesInScroll objectAtIndex:i];
//            NSLog(@"deleteImagesInScroll count %lu", (unsigned long)[self.deleteImagesInScroll count]);
            [self.scrollView bringSubviewToFront:deleteImageView];
            
            nextDeleteImageFrame = deleteImageView.frame;
            deleteImageView.frame = deleteImageFrame;
            deleteImageFrame = nextDeleteImageFrame;
            deleteImageView.tag = i;
            
            
            CGFloat padding = 5.0;
            CGFloat width   = 70.0;
            
            CGSize contentSize = CGSizeZero;
            //        contentSize.width = self.scrollView.frame.size.width * assets.count;
            contentSize.width = (width + padding) * ([self.imagesInScroll count] + 1);
            
            contentSize.height = self.scrollView.frame.size.height;
            self.scrollView.contentSize = contentSize;
            
            //        if (!removedLastDeleteImage) {
            //            UIImageView *lastDeleteImageView = [self.deleteImagesInScroll lastObject];
            //            [self.deleteImagesInScroll removeLastObject];
            //            [lastDeleteImageView removeFromSuperview];
            //            removedLastDeleteImage = YES;
            //        }
        }

        
    } completion:^(BOOL finished) {
        [tap.view removeFromSuperview];
        
    }];

}

#pragma Image Removal

- (UIImageView *)createEditForImageOnFrame:(CGRect) frame {
    
//    frame.size.width = 5;
//    frame.size.height = 5;
    
    UIImage *image = [UIImage imageNamed:@"btn_selected_remove_pressed"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.frame = frame;
    
    return imageView;
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
