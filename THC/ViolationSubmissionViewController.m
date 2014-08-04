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
#import "SubmissionValidationViewController.h"
#import "MBProgressHUD.h"
#import "PhotoPickerCell.h"
#import "PhotoViewerController.h"
#import "EBPhotoPagesController.h"
#import "EBPhotoPagesFactory.h"
#import "EBTagPopover.h"
#import "ViolationPhoto.h"
#import "PhotoComment.h"
#import "PhotoTag.h"


#define greyColor   [UIColor colorWithRed: 247.0f/255.0f green: 247.0f/255.0f blue: 247.0f/255.0f alpha: 1]
#define orangeColor [UIColor colorWithRed: 255.0f/255.0f green: 116.0f/255.0f blue: 47.0f/255.0f alpha: 1]
#define whiteColor  [UIColor whiteColor]

#define LanguageList  @{@"English", @"Spanish", @"Chinese", @"Mandarin", @"Vietnamese", @"Phillipino", nil}
#define AllFields     @[@"name", @"languageSpoken", @"phone", @"email", @"hotel", @"unit", @"violationDescription", @"violationType", @"multiUnitPetition", @"photoPicker", @"submit"]
#define FieldList     @[@"name", @"languageSpoken", @"phone", @"email"]
#define PersonalInfo  @[@"name", @"languageSpoken", @"phone", @"email"]
#define HotelInfo     @[@"hotel", @"unit"]
#define ViolationInfo @[@"violationType", @"violationDescription", @"multiUnitPetition", @"photoPicker"]
#define SubmitInfo    @[@"submit"]
//#define FormFields    @{@"0": PersonalInfo, @"1": HotelInfo}
#define FormFields    @{@"0": PersonalInfo, @"1": HotelInfo, @"2": ViolationInfo,  @"3": SubmitInfo}
#define FormSectionHeader    @{@"0": @"Tenant Information", @"1": @"Hotel Information", @"2": @"Violation Details", @"3": @""}

#define TRANSITION_DURATION 1.0


//#define FieldList    @[@"name", @"languageSpoken", @"phone", @"email", @"hotel", @"address",   @"violationDescription"]


@interface ViolationSubmissionViewController ()

@property (strong, nonatomic) NSData                  *imageData;
@property (strong, nonatomic) NSString                *violationDescription;
@property (strong, nonatomic) Case                    *myCase;
@property (strong, nonatomic) NSMutableArray          *imagesInScroll;
@property (strong, nonatomic) NSMutableArray          *imagesToSubmit;
//@property (strong, nonatomic) NSMutableArray          *imagesToShow;
@property (strong, nonatomic) NSMutableArray          *violationPhotos;
@property (strong, nonatomic) NSMutableArray          *imagesToSubmitOrientation;
@property (strong, nonatomic) NSMutableArray          *deleteImagesInScroll;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (strong, nonatomic) NSArray                 *fields;
@property (strong, nonatomic) NSDictionary            *formFields;
@property (strong, nonatomic) NSDictionary            *formSectionHeader;
@property (strong, nonatomic) UITapGestureRecognizer  *tapGestureRecognizer;
@property (strong, nonatomic) NSIndexPath             *currentIndexPath;
@property (strong, nonatomic) ViolationForm           *violationForm;
@property (assign)            BOOL                    showFilledForm;
@property (assign)            BOOL                    isPresenting;
@property (strong, nonatomic) CLLocationManager       *locationManager;
@property (strong, nonatomic) PhotoPickerCell         *photoPickerCell;
@property (nonatomic)         CLLocationDegrees       currentLatitude;
@property (nonatomic)         CLLocationDegrees       currentLongitude;


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
PhotoPickerCell                 *_stubPhotoPickerCell;

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

- (void)viewWillDisappear:(BOOL)animated {

    if (self.locationManager) {
        [self.locationManager stopUpdatingLocation];
    }
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
//    self.navigationController.navigationBar.barTintColor = self.tableView.backgroundColor;
    self.navigationController.navigationBar.topItem.title = @"Create Report";
    self.navigationController.navigationBar.backgroundColor = orangeColor;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: whiteColor, NSFontAttributeName: [UIFont systemFontOfSize:18]};
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
//                                                                                           target:self
//                                                                                           action:@selector(cancelButtonAction)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_navbar_close_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonAction)];

//    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = whiteColor;
    

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Submit"
                                                                    style:UIBarButtonItemStylePlain
                                                                    target:self action:@selector(submitForm)];
    
//    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    [self.tableView setBackgroundColor:greyColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshForm)
                                                 name:@"Addresses Retrieved"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshFormWithNearestHotel)
                                                 name:@"Nearest Hotel Retrieved"
                                               object:nil];
    
    self.fields = AllFields;
    self.formFields = FormFields;
    self.formSectionHeader = FormSectionHeader;
    
    if (!self.violationForm) {
        self.violationForm = [[ViolationForm alloc] init];
        [self.violationForm populateHotelsWithSuccess:^(BOOL success) {
            [self startLocationManager];
        } error:^(NSError *error) {
            NSLog(@"Could not get the Hotel");
        }];
        
        self.showFilledForm = [self.violationForm addloggedInUserDetails];
//        self.showFilledForm = NO;
//        [self startLocationManager];
        
    }
    
    [self registerFieldCells];
    
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    [self setupKeyboardDismissGestures];
    [self registerForKeyboardNotifications];
    [self.tableView reloadData];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera library"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
    } else {
        self.picker = [[UIImagePickerController alloc] init];
        self.picker.delegate = self;
        //self.picker.allowsEditing = YES;
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        _stubPhotoPickerCell.photoScrollView.backgroundColor = [UIColor redColor];
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 48, 0, 10)];

        _stubPhotoPickerCell.photoScrollView.delegate = self;
        
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        self.isPresenting = YES;
        
        self.imagesInScroll   = [NSMutableArray array];
        self.imagesToSubmit   = [NSMutableArray array];
//        self.imagesToShow     = [NSMutableArray array];
        self.violationPhotos  = [NSMutableArray array];

        self.imagesToSubmitOrientation = [NSMutableArray array];
        self.deleteImagesInScroll = [NSMutableArray array];
        
        UINib *cellNib = [UINib nibWithNibName:@"PhotoPickerCell" bundle:nil];
        [self.tableView registerNib:cellNib forCellReuseIdentifier:@"PhotoPicker"];
        self.photoPickerCell = [cellNib instantiateWithOwner:nil options:nil][0];

    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

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
//    NSLog(@"using prefilled form");
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
        } else if ([fieldName isEqualToString:@"photoPicker"]) {
            UINib *cellNib = [UINib nibWithNibName:@"PhotoPickerCell" bundle:nil];
            [self.tableView registerNib:cellNib forCellReuseIdentifier:@"PhotoPicker"];
            _stubPhotoPickerCell = [cellNib instantiateWithOwner:nil options:nil][0];
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
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    
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
        [self.tableView scrollToRowAtIndexPath:self.currentIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
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
    NSArray *sectionContent = [self.formFields objectForKey:[NSString stringWithFormat:@"%ld", (long)section]];
    
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
        nameCell.delegate = self.violationForm;
        if (self.showFilledForm) {
            [nameCell getFieldValueFromform];
        } else {
            nameCell.nameTextField.text = @"Testing";
        }
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
    }  else if ([fieldName isEqualToString:@"violationDescription"]) {
        ViolationDescriptionFieldCell *violationCell = (ViolationDescriptionFieldCell *)cell;
        violationCell.delegate = self.violationForm;
        if (self.showFilledForm) {
            [violationCell getFieldValueFromform];
        } else {
            violationCell.violationDescriptionTextField.text = @"Testing Testing Testing Testing Testing Testing Testing Testing Testing Testing Testing TestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTestingTesting";
        }
    } else if ([fieldName isEqualToString:@"violationType"]) {
        ViolationTypeFieldCell *violationTypeCell = (ViolationTypeFieldCell *)cell;
        violationTypeCell.violationTypeTextField.text = @"Testing";
    } else if ([fieldName isEqualToString:@"multiUnitPetition"]) {
        MultiUnitFieldCell *multiUniteCell = (MultiUnitFieldCell *)cell;
        multiUniteCell.multiUnitField.text = @"Testing";
    } else if ([fieldName isEqualToString:@"submit"]) {
        SubmitCell *submitCell = (SubmitCell *)cell;
        UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
        backView.backgroundColor = [UIColor clearColor];
        submitCell.backgroundView = backView;
//        multiUniteCell.multiUnitField.text = @"Testing";
    } else {
        
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
        [_stubEmailCell layoutSubviews];
        height = [_stubEmailCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        height = 45;
    } else if ([fieldName isEqualToString:@"phone"]) {
        [self configureCell:_stubPhoneCell atIndexPath:indexPath];
        [_stubPhoneCell layoutSubviews];
        height = [_stubPhoneCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        height = 45;
    } else if ([fieldName isEqualToString:@"hotel"]) {
        [self configureCell:_stubHotelCell atIndexPath:indexPath];
        [_stubHotelCell layoutSubviews];
        height = [_stubPhoneCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    } else if ([fieldName isEqualToString:@"unit"]) {
        [self configureCell:_stubUnitCell atIndexPath:indexPath];
        [_stubUnitCell layoutSubviews];
        height = [_stubPhoneCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        height = 45;
    } else if ([fieldName isEqualToString:@"violationDescription"]) {
        [self configureCell:_stubViolationCell atIndexPath:indexPath];
        [_stubViolationCell layoutSubviews];
        height = [_stubViolationCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//        NSLog(@"height for violation description cell: %f", height);
        if (height < 90) {
            height = 90;
        }

    } else if ([fieldName isEqualToString:@"violationType"]) {
        [self configureCell:_stubViolationTypeCell atIndexPath:indexPath];
        [_stubViolationTypeCell layoutSubviews];
        height = [_stubViolationTypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        height = 45;
    } else if ([fieldName isEqualToString:@"multiUnitPetition"]) {
        [self configureCell:_stubMultiUnitFieldCell atIndexPath:indexPath];
        [_stubMultiUnitFieldCell layoutSubviews];
        height = [_stubMultiUnitFieldCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        height = 45;
    } else if ([fieldName isEqualToString:@"photoPicker"]) {
        [self configureCell:_stubPhotoPickerCell atIndexPath:indexPath];
        [_stubPhotoPickerCell layoutSubviews];
        height = [_stubPhotoPickerCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        height = 124;
    }else if ([fieldName isEqualToString:@"submit"]) {
        [self configureCell:_stubSubmitCell atIndexPath:indexPath];
        [_stubSubmitCell layoutSubviews];
        height = [_stubSubmitCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        height = 58;
    }
    
//    NSLog(@"hieght for cell at section %ld row %ld ------> %f  %@", (long)indexPath.section, (long)indexPath.row, height+1, fieldName);
    
    
    return height + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSArray *sectionContent = [self.formFields objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.section]];

    NSString *fieldName = [sectionContent objectAtIndex:indexPath.row];
    
    if ([fieldName isEqualToString:@"name"]) {
        NameFieldCell *cell = [ tableView dequeueReusableCellWithIdentifier:@"NameFieldCell" ];
        cell.delegate = self.violationForm;
        if (self.showFilledForm) {
            [cell getFieldValueFromform];
        }
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
        cell.submitDelegate = self;

//        [cell.submitButton addTarget:self
//                     action:@selector(submitForm)
//           forControlEvents:UIControlEventTouchUpInside];
        cell.submitButton.userInteractionEnabled = YES;
        [cell.submitButton becomeFirstResponder];

        
        cell.delegate = self.violationForm;
        return cell;
    } else if ([fieldName isEqualToString:@"photoPicker"]) {
//        PhotoPickerCell *cell = [ tableView dequeueReusableCellWithIdentifier:@"PhotoPicker" ];
        PhotoPickerCell *cell = self.photoPickerCell;
        cell.delegate = self.violationForm;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(launchPhotoPicker:)];
        tap.numberOfTapsRequired = 1;
        
        cell.addPicture.userInteractionEnabled = YES;
        cell.userInteractionEnabled = YES;
        [cell.addPicture addGestureRecognizer:tap];
        return cell;
    }
    
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[self tableView] endEditing:YES];
    
    self.currentIndexPath = indexPath;
//    NSLog(@"current index path: %ld", (long)self.currentIndexPath.row);
    
    NSArray *sectionContent = [self.formFields objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.section]];

    NSString *fieldName  = [sectionContent objectAtIndex:indexPath.row];
    if ([fieldName isEqualToString:@"languageSpoken"]) {
        [self.tapGestureRecognizer setEnabled:NO];
        CGRect rectOfCellInTableView = [tableView rectForRowAtIndexPath:indexPath];
        CGRect rectOfCellInSuperview = [tableView convertRect:rectOfCellInTableView toView:[tableView superview]];
//        NSLog(@"rect of Spoken language cell in superview %@", NSStringFromCGRect(rectOfCellInSuperview));
//        NSLog(@"rect of Spoken language cell in tableview %@", NSStringFromCGRect(rectOfCellInTableView));
        
        
//        if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
//            NSLog(@"portrait orientation");
//        }
        SpokenLanguageFieldCell *cell = (SpokenLanguageFieldCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell showMenu:rectOfCellInSuperview onView:self.tableView forOrientation:self.interfaceOrientation];
    } else    if ([fieldName isEqualToString:@"hotel"]) {
        [self.tapGestureRecognizer setEnabled:NO];
        CGRect rectOfCellInTableView = [tableView rectForRowAtIndexPath:indexPath];
        CGRect rectOfCellInSuperview = [tableView convertRect:rectOfCellInTableView toView:[tableView superview]];
//        NSLog(@"rect of Spoken language cell in superview %@", NSStringFromCGRect(rectOfCellInSuperview));
//        NSLog(@"rect of Spoken language cell in tableview %@", NSStringFromCGRect(rectOfCellInTableView));
        
        
//        if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
//            NSLog(@"portrait orientation");
//        }
        HotelFieldCell *cell = (HotelFieldCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell showMenu:rectOfCellInSuperview onView:self.tableView forOrientation:self.interfaceOrientation];
    } else    if ([fieldName isEqualToString:@"violationType"]) {
        [self.tapGestureRecognizer setEnabled:NO];
        CGRect rectOfCellInTableView = [tableView rectForRowAtIndexPath:indexPath];
        CGRect rectOfCellInSuperview = [tableView convertRect:rectOfCellInTableView toView:[tableView superview]];
//        NSLog(@"rect of Spoken language cell in superview %@", NSStringFromCGRect(rectOfCellInSuperview));
//        NSLog(@"rect of Spoken language cell in tableview %@", NSStringFromCGRect(rectOfCellInTableView));
        
        
//        if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
//            NSLog(@"portrait orientation");
//        }
        ViolationTypeFieldCell *cell = (ViolationTypeFieldCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell showMenu:rectOfCellInSuperview onView:self.tableView forOrientation:self.interfaceOrientation];
    } else    if ([fieldName isEqualToString:@"multiUnitPetition"]) {
        [self.tapGestureRecognizer setEnabled:NO];
        CGRect rectOfCellInTableView = [tableView rectForRowAtIndexPath:indexPath];
        CGRect rectOfCellInSuperview = [tableView convertRect:rectOfCellInTableView toView:[tableView superview]];
//        NSLog(@"rect of Spoken language cell in superview %@", NSStringFromCGRect(rectOfCellInSuperview));
//        NSLog(@"rect of Spoken language cell in tableview %@", NSStringFromCGRect(rectOfCellInTableView));
//        
//        
//        if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
//            NSLog(@"portrait orientation");
//        }
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
//        NSLog(@"selecting violation description cell");
        ViolationDescriptionFieldCell *cell = (ViolationDescriptionFieldCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.violationDescriptionTextField.userInteractionEnabled = YES;
        [cell.violationDescriptionTextField becomeFirstResponder];
    }  else if ([fieldName isEqualToString:@"submit"]) {
        SubmitCell *cell = (SubmitCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.submitButton.userInteractionEnabled = YES;
        [cell.submitButton becomeFirstResponder];
//        [self.tapGestureRecognizer setEnabled:NO];
    } else if ([fieldName isEqualToString:@"photoPicker"]) {
        [self.tapGestureRecognizer setEnabled:NO];
    }else {
        [self.tapGestureRecognizer setEnabled:YES];
    }
    
    [tableView  deselectRowAtIndexPath:indexPath  animated:YES];

 
}

#pragma mark -
#pragma Dynamic Form Changes

- (void)refreshForm {
//    self.formController.form = self.formController.form;
    [self.tableView reloadData];
}

- (void)refreshFormWithNearestHotel {
    [self.violationForm assignNearestHotel];
    self.showFilledForm = YES;

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
    }
}

- (void)submitForm {
    UIImage* firstImage;
    
    if ([self.imagesToSubmit count]) {
        firstImage = ((UIImageView*)(self.imagesInScroll[0])).image;
    } else
    {
        firstImage = nil;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [self.violationForm createCaseWithDescription:self.violationDescription withImageDataList:self.imagesToSubmit withOrientation:self.imagesToSubmitOrientation  completion:^(Case* createdCase){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        SubmissionValidationViewController *submissionvc =
        [[SubmissionValidationViewController alloc] initWithCase:createdCase withTopPhoto:firstImage];
//        UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:submissionvc];
        [self presentViewController:submissionvc animated:YES completion:nil];
    } error:^(NSError * onError) {
        NSLog(@"Error creating Case!");
    }];

}

#pragma ImagePicker Delegate Protocols
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    CGFloat padding = 10.0;
    CGRect imageViewFrame = CGRectInset(_stubPhotoPickerCell.photoScrollView.bounds, padding, padding);
    imageViewFrame.origin.x = _stubPhotoPickerCell.photoScrollView.frame.size.width + padding;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:chosenImage];
    imageView.frame = imageViewFrame;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_stubPhotoPickerCell.photoScrollView addSubview:imageView];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    //self.nextButton.enabled = YES;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma custom picker delegate
- (void) finishedPhotoPicker:(UIViewController *)picker withUserSelectedAssets:(NSArray *)assets {
    
//    NSLog(@"userSelectedAssets %@", assets);
    
    //[self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //[self.scrollView.subviews removeFromSuperview];
    for (UIView *view in self.photoPickerCell.photoScrollView.subviews) {
        if (view.tag != 10000) {
            [view removeFromSuperview];
        }
    }
    
    CGPoint scrollViewCenter = CGPointMake(self.photoPickerCell.photoScrollView.frame.size.width/2, self.photoPickerCell.photoScrollView.frame.size.height/2);
    CGPoint activityCenter = [self.view convertPoint:scrollViewCenter fromView:self.photoPickerCell.photoScrollView];
    
    NSLog(@"scroll view centre %@ :  %@", NSStringFromCGPoint(scrollViewCenter), NSStringFromCGPoint(activityCenter));
//
//    
    self.activityView.center = activityCenter;
    [self.view addSubview:self.activityView];
//    self.activityView.hidden = NO;
//    self.activityView.hidesWhenStopped = YES;

//    [self.photoPickerCell.photoScrollView addSubview:self.activityView];
//    [self.photoPickerCell.photoScrollView bringSubviewToFront:self.activityView];


    self.photoPickerCell.photoScrollView.contentSize = CGSizeZero;
    [self.activityView startAnimating];

    
    // Dismiss the picker controller.
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (assets.count == 0) {
            [self.activityView stopAnimating];
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        
        // ScrollView setup.
        CGFloat padding = 20.0;
        CGFloat width   = 86.0;

        CGSize contentSize = CGSizeZero;
        contentSize.width = (width + padding) * (assets.count);

        contentSize.height = self.photoPickerCell.photoScrollView.frame.size.height;
        self.photoPickerCell.photoScrollView.contentSize = contentSize;
        
        
        [self.imagesInScroll removeAllObjects];
        [self.imagesToSubmit removeAllObjects];
//        [self.imagesToShow removeAllObjects];
        [self.imagesToSubmitOrientation removeAllObjects];
        [self.violationPhotos removeAllObjects];

        
        __block int index = 0;
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        for (ALAsset *asset in assets) {
            
            //            NSLog(@"scroll view frame %@", NSStringFromCGRect(self.scrollView.bounds));
            
            CGRect imageViewFrame = CGRectInset(self.photoPickerCell.photoScrollView.bounds, padding, padding);
            //            NSLog(@"image view frame %@", NSStringFromCGRect(imageViewFrame));
            
            imageViewFrame.size.width = width;
            imageViewFrame.size.height = width;
            imageViewFrame.origin.x = (width + padding) * index;
            
            UIImage *image = [[UIImage alloc] initWithCGImage:asset.thumbnail];
            
            //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //                UIImage *fullResImage  = [[UIImage alloc] initWithCGImage:asset.defaultRepresentation.fullResolutionImage scale:asset.defaultRepresentation.scale orientation:asset.defaultRepresentation.orientation];
            UIImage *fullResImage = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage scale:asset.defaultRepresentation.scale orientation:UIImageOrientationUp];
//            [self.imagesToShow addObject:fullResImage];
            
            ViolationPhoto *photo = [ViolationPhoto photoWithProperties:@{@"image": fullResImage
                                                                          }];
            [self.violationPhotos addObject:photo];
            
            NSData  *imageData = UIImageJPEGRepresentation(fullResImage, 0);
            [self.imagesToSubmit addObject:imageData];
            [self.imagesToSubmitOrientation addObject:[NSString stringWithFormat:@"%d", asset.defaultRepresentation.orientation]];
            //                NSLog(@"image dimesntions %@", NSStringFromCGSize(asset.defaultRepresentation.dimensions));
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = imageViewFrame;
            //imageView.contentMode = UIViewContentModeCenter;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            //                imageView.layer.cornerRadius = 4.f;
            //                imageView.layer.borderWidth = 1.f;
            
            imageView.backgroundColor = [UIColor colorWithRed: 0.196f green: 0.325f blue: 0.682f alpha: 1];
            imageView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
            [imageView setClipsToBounds:YES];
            
            UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPhotoViewer)];
            imageTap.numberOfTapsRequired = 1;
            [imageView addGestureRecognizer:imageTap];
            imageView.userInteractionEnabled = YES;
            
            
            
            CGRect deleteFrame = CGRectInset(imageView.frame, 28, 28);
            deleteFrame.origin.x += width / 2;
            deleteFrame.origin.y -= width / 2;
            deleteFrame.size.height = 28;
            deleteFrame.size.width  = 28;
            UIImageView *deleteImageView = [self createEditForImageOnFrame:deleteFrame];
            //            NSLog(@"delete view frame %@", NSStringFromCGRect(deleteImageView.frame));
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteImage:)];
            tap.numberOfTapsRequired = 1;
            
            [deleteImageView addGestureRecognizer:tap];
            deleteImageView.userInteractionEnabled = YES;
            deleteImageView.tag = [self.imagesInScroll count];
            
            index++;
            
            
            [self.photoPickerCell.photoScrollView addSubview:imageView];
            
            [self.photoPickerCell.photoScrollView addSubview:deleteImageView];
            [self.imagesInScroll addObject:imageView];
            [self.deleteImagesInScroll addObject:deleteImageView];
        }
        
        [self.activityView stopAnimating];
        [self.activityView removeFromSuperview];
        
        [self.photoPickerCell.photoScrollView flashScrollIndicators];
    }];

    
}

- (void) finishedPhotoPicker:(UIViewController *)picker withCameraTakenImages:(NSArray *)selectedImages {
    
    
    _stubPhotoPickerCell.photoScrollView.contentSize = CGSizeZero;
    // Show some activity.
    
    for (UIView *view in self.photoPickerCell.photoScrollView.subviews) {
        if (view.tag != 10000) {
            [view removeFromSuperview];
        }
    }
    
    CGPoint scrollViewCenter = CGPointMake(self.photoPickerCell.photoScrollView.frame.size.width/2, self.photoPickerCell.photoScrollView.frame.size.height/2);
    CGPoint activityCenter = [self.view convertPoint:scrollViewCenter fromView:self.photoPickerCell.photoScrollView];
    
    self.activityView.center = activityCenter;
    
    [self.view addSubview:self.activityView];
//    [self.photoPickerCell.photoScrollView addSubview:self.activityView];

    [self.activityView startAnimating];
    
    // Dismiss the picker controller.
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (selectedImages.count == 0) {
            [self.activityView stopAnimating];
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        
        // ScrollView setup.
        CGFloat padding = 20.0;
        CGFloat width   = 86.0;
        
        CGSize contentSize = CGSizeZero;
        contentSize.width = (width + padding) * (selectedImages.count);
        
        contentSize.height = self.photoPickerCell.photoScrollView.frame.size.height;
        self.photoPickerCell.photoScrollView.contentSize = contentSize;
        
//        // PageControl setup.
//        self.pageControl.hidden = NO;
//        self.pageControl.numberOfPages = selectedImages.count;
        
        int index = 0;
        
        [self.imagesInScroll removeAllObjects];
        [self.imagesToSubmit removeAllObjects];
        [self.violationPhotos removeAllObjects];

        
        for (UIImage *image in selectedImages) {
            
            CGRect imageViewFrame = CGRectInset(self.photoPickerCell.photoScrollView.bounds, padding, padding);
            imageViewFrame.size.width = width;
            imageViewFrame.size.height = width;
            imageViewFrame.origin.x = (width + padding) * index;
            
            
            NSData  *imageData = UIImageJPEGRepresentation(image, 7);
            [self.imagesToSubmit addObject:imageData];
//            [self.imagesToSubmitOrientation addObject:[NSString stringWithFormat:@"%d", UIImageOrientationUp]];

//            [self.imagesToShow addObject:image];


            ViolationPhoto *photo = [ViolationPhoto photoWithProperties:@{@"image": image
                                                                          }];
            [self.violationPhotos addObject:photo];

            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = imageViewFrame;
            //imageView.contentMode = UIViewContentModeCenter;
            //imageView.contentMode = UIViewContentModeCenter;
//            imageView.layer.cornerRadius = 4.f;
//            imageView.layer.borderWidth = 1.f;
            
            imageView.backgroundColor = [UIColor colorWithRed: 0.196f green: 0.325f blue: 0.682f alpha: 1];
            imageView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
            [imageView setClipsToBounds:YES];
            
            UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPhotoViewer)];
            imageTap.numberOfTapsRequired = 1;
            [imageView addGestureRecognizer:imageTap];
            imageView.userInteractionEnabled = YES;
            
            CGRect deleteFrame = CGRectInset(imageView.frame, 28, 28);
            deleteFrame.origin.x += width / 2;
            deleteFrame.origin.y -= width / 2;
            deleteFrame.size.height = 28;
            deleteFrame.size.width  = 28;
            UIImageView *deleteImageView = [self createEditForImageOnFrame:deleteFrame];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteImage:)];
            tap.numberOfTapsRequired = 1;
            
            [deleteImageView addGestureRecognizer:tap];
            deleteImageView.userInteractionEnabled = YES;
            deleteImageView.tag = [self.imagesInScroll count];
            
            index++;
            
            [self.photoPickerCell.photoScrollView addSubview:imageView];
            [self.photoPickerCell.photoScrollView addSubview:deleteImageView];
            [self.imagesInScroll addObject:imageView];
            [self.deleteImagesInScroll addObject:deleteImageView];

            
        }
        
        [self.activityView stopAnimating];
        
        [self.photoPickerCell.photoScrollView flashScrollIndicators];
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

- (void)launchPhotoPicker:(id)sender {
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
        [self.imagesToSubmit removeObjectAtIndex:tap.view.tag];
//        [self.imagesToShow removeObjectAtIndex:tap.view.tag];

        if (self.imagesToSubmitOrientation.count) {
            [self.imagesToSubmitOrientation removeObjectAtIndex:tap.view.tag];
        }
        
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
            [self.photoPickerCell.photoScrollView bringSubviewToFront:deleteImageView];
            
            nextDeleteImageFrame = deleteImageView.frame;
            deleteImageView.frame = deleteImageFrame;
            deleteImageFrame = nextDeleteImageFrame;
            deleteImageView.tag = i;
            
            
            CGFloat padding = 20.0;
            CGFloat width   = 86.0;
            
            CGSize contentSize = CGSizeZero;
            contentSize.width = (width + padding) * ([self.imagesInScroll count]);
            
            contentSize.height = self.photoPickerCell.photoScrollView.frame.size.height;
            self.photoPickerCell.photoScrollView.contentSize = contentSize;
            
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

- (void)deleteImageAtIndex:(NSUInteger) index {
    
    for (UIView *view in self.photoPickerCell.photoScrollView.subviews) {
        [view removeFromSuperview];
    }
    [self.imagesInScroll removeObjectAtIndex:index];
    [self.imagesToSubmit removeObjectAtIndex:index];
//    [self.imagesToShow removeObjectAtIndex:index];
    
    if (self.imagesToSubmitOrientation.count) {
        [self.imagesToSubmitOrientation removeObjectAtIndex:index];
    }
    
    CGFloat padding = 20.0;
    CGFloat width   = 86.0;
    
    CGSize contentSize = CGSizeZero;
//    contentSize.width = (width + padding) * (self.imagesInScroll.count) + padding;
    contentSize.width = (width + padding) * (self.imagesInScroll.count);

    
    contentSize.height = self.photoPickerCell.photoScrollView.frame.size.height;
    self.photoPickerCell.photoScrollView.contentSize = contentSize;
    
    for (NSUInteger imageIndex=0; imageIndex<[self.imagesInScroll count]; imageIndex++) {
        
        CGRect imageViewFrame = CGRectInset(self.photoPickerCell.photoScrollView.bounds, padding, padding);

        imageViewFrame.size.width = width;
        imageViewFrame.size.height = width;
//        imageViewFrame.origin.x = (width + padding) * index + padding;
        imageViewFrame.origin.x = (width + padding) * imageIndex;

        
        UIImageView *imageView = [self.imagesInScroll objectAtIndex:imageIndex];
        imageView.frame = imageViewFrame;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        imageView.layer.cornerRadius = 4.f;
//        imageView.layer.borderWidth = 1.f;
        
        imageView.backgroundColor = [UIColor colorWithRed: 0.196f green: 0.325f blue: 0.682f alpha: 1];
        imageView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
        [imageView setClipsToBounds:YES];
        
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPhotoViewer)];
        imageTap.numberOfTapsRequired = 1;
        [imageView addGestureRecognizer:imageTap];
        imageView.userInteractionEnabled = YES;
        
        
        
//        CGRect deleteFrame = CGRectInset(imageView.frame, padding, padding);
//        deleteFrame.origin.x += width - 4*padding;
//        deleteFrame.origin.y -= 2*padding;
//        deleteFrame.size.height = 4*padding;
//        deleteFrame.size.width  = 4*padding;
        
        CGRect deleteFrame = CGRectInset(imageView.frame, 28, 28);
        deleteFrame.origin.x += width / 2;
        deleteFrame.origin.y -= width / 2;
        deleteFrame.size.height = 28;
        deleteFrame.size.width  = 28;
        
        UIImageView *deleteImageView = [self.deleteImagesInScroll objectAtIndex:imageIndex];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteImage:)];
        tap.numberOfTapsRequired = 1;
        
        [deleteImageView addGestureRecognizer:tap];
        deleteImageView.userInteractionEnabled = YES;
        deleteImageView.tag = imageIndex;
        
        
        [self.photoPickerCell.photoScrollView addSubview:imageView];
        
        [self.photoPickerCell.photoScrollView addSubview:deleteImageView];
    }

}

- (void)showPhotoViewer {
    
//    PhotoViewerController *pvc = [[PhotoViewerController alloc] init];
//    [pvc setImagesForViewing:self.imagesToShow withOrientations:self.imagesToSubmitOrientation];
//    [self.navigationController presentViewController:pvc animated:YES completion:nil];
    
    EBPhotoPagesController *photoPagesController = [[EBPhotoPagesController alloc] initWithDataSource:self delegate:self];
    
//    photoPagesController.modalPresentationStyle = UIModalPresentationCustom;
//    photoPagesController.transitioningDelegate = self;
    
    [self presentViewController:photoPagesController animated:YES completion:nil];
}

#pragma Mark - Transition Delegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    self.isPresenting = YES;

    return self;
    
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
 
    self.isPresenting = NO;

    return self;
}


// This is used for percent driven interactive transitions, as well as for container controllers that have companion animations that might need to
// synchronize with the main animation.
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    return TRANSITION_DURATION;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    toViewController.view.frame = containerView.frame;
    [containerView addSubview:toViewController.view];
    
    toViewController.view.alpha = 0;
//    toViewController.view.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:TRANSITION_DURATION animations:^{
        toViewController.view.alpha = 1;
//        toViewController.view.transform = CGAffineTransformMakeScale(0.9, 0.9);

    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    
//    CGRect beginFrame;
//    CGRect endFrame;
//    
//    UIView *move = nil;
//    ViolationSubmissionViewController *first = nil;
//    EBPhotoPagesController *second = nil;
//    
//    if (self.isPresenting) {
//        
//        first = (ViolationSubmissionViewController *)fromViewController;
//        second = (EBPhotoPagesController *)toViewController;
//        UIImageView *moveImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[self.imagesToSubmit objectAtIndex:0] ]];
//        UIImageView *imageView = [self.imagesInScroll objectAtIndex:0];
//        CGRect imageFrame = [self.view convertRect:imageView.frame fromView:self.photoPickerCell.photoScrollView];
//        NSLog(@"image view frame frame %@", NSStringFromCGRect(imageView.frame));
//        NSLog(@"new frame %@", NSStringFromCGRect(imageFrame));
//        
//        CGRect newRect = CGRectInset(imageFrame, -10, -10);
//        NSLog(@"new rect %@", NSStringFromCGRect(newRect));
//
//        UIView *moveView = [[UIView alloc] initWithFrame:newRect];
//        [moveView addSubview:moveImageView];
//        
//        
//
//        
//        beginFrame = imageFrame;
//        endFrame = second.view.frame;
//        
//        move = [moveView snapshotViewAfterScreenUpdates:YES];
//        move.frame = beginFrame;
//        imageView.alpha = 0;
//        first.view.alpha = 1;
//        
//    } else {
//        
//        first = (ViolationSubmissionViewController *)toViewController;
//        second = (EBPhotoPagesController *)fromViewController;
//        
//        UIImageView *imageView = [self.imagesInScroll objectAtIndex:0];
//
//        endFrame = imageView.frame;
//        beginFrame = second.view.frame;
//        
//        move = [imageView snapshotViewAfterScreenUpdates:YES];
//        move.frame = beginFrame;
//        second.view.alpha = 0;
////        second.view.alpha = 1;
//        
//    }
//    
//    [containerView addSubview:move];
//    
//    [UIView animateWithDuration:TRANSITION_DURATION animations:^{
//        NSLog(@"Animation...");
//        move.frame = endFrame;
//        fromViewController.view.alpha = 0;
//        toViewController.view.alpha = 1;
//        
//        
//    } completion:^(BOOL finished) {
//        NSLog(@"Completion...");
//        [move removeFromSuperview];
//        [containerView addSubview:toViewController.view];
//        [transitionContext completeTransition: YES];
    
//        if (self.isPresenting) {
//            second.imageView.alpha = 1;
//        } else {
//            first.imageView.alpha = 1;
//        }
        
        
//    }];
}

#pragma Location

- (void)startLocationManager {
    if(!self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    
    // Set Location Manager delegate
    [self.locationManager setDelegate:self];
    
    // Set location accuracy levels
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    
    // Update again when a user moves distance in meters
    [self.locationManager setDistanceFilter:15];
        
    // Start updating location
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    //NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    //NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    self.currentLatitude = newLocation.coordinate.latitude;
    self.currentLongitude = newLocation.coordinate.longitude;
    
    if (self.violationForm) {
        [self.violationForm computeHotelDistancesFromLocation:newLocation ];
        NSLog(@"Done with computeHotelDistancesFromLocation");
    }
}

#pragma Image Removal

- (UIImageView *)createEditForImageOnFrame:(CGRect) frame {
    
//    frame.size.width = 5;
//    frame.size.height = 5;
    
    UIImage *image = [UIImage imageNamed:@"btn_selected_remove_normal"];
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

#pragma mark - EBPhotoPagesDataSource

- (BOOL)photoPagesController:(EBPhotoPagesController *)photoPagesController
    shouldExpectPhotoAtIndex:(NSInteger)index
{
    if(index < self.violationPhotos.count){
        return YES;
    }
    
    return NO;
}

- (void)photoPagesController:(EBPhotoPagesController *)controller
                imageAtIndex:(NSInteger)index
           completionHandler:(void (^)(UIImage *))handler
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        ViolationPhoto *photo = self.violationPhotos[index];
        handler(photo.image);
    });
}

- (void)photoPagesController:(EBPhotoPagesController *)controller
         tagsForPhotoAtIndex:(NSInteger)index
           completionHandler:(void (^)(NSArray *))handler
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        ViolationPhoto *photo = self.violationPhotos[index];
        
        handler(photo.tags);
    });
}


- (void)photoPagesController:(EBPhotoPagesController *)controller
     commentsForPhotoAtIndex:(NSInteger)index
           completionHandler:(void (^)(NSArray *))handler
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        ViolationPhoto *photo = self.violationPhotos[index];

        handler(photo.comments);
    });
}

- (void)photoPagesController:(EBPhotoPagesController *)controller
     metaDataForPhotoAtIndex:(NSInteger)index
           completionHandler:(void (^)(NSDictionary *))handler
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        ViolationPhoto *photo = self.violationPhotos[index];
        
        handler(photo.metaData);
    });
}


- (void)photoPagesController:(EBPhotoPagesController *)controller
numberOfcommentsForPhotoAtIndex:(NSInteger)index
           completionHandler:(void (^)(NSInteger))handler
{
    ViolationPhoto *photo = self.violationPhotos[index];
    
    handler(photo.comments.count);
}


- (void)photoPagesController:(EBPhotoPagesController *)photoPagesController
       didReportPhotoAtIndex:(NSInteger)index
{
    NSLog(@"Reported photo at index %li", (long)index);
    //Do something about this image someone reported.
}



- (void)photoPagesController:(EBPhotoPagesController *)controller
            didDeleteComment:(id<EBPhotoCommentProtocol>)deletedComment
             forPhotoAtIndex:(NSInteger)index
{
    ViolationPhoto *photo = self.violationPhotos[index];
    NSMutableArray *remainingComments = [NSMutableArray arrayWithArray:photo.comments];
    [remainingComments removeObject:deletedComment];
    [photo setComments:[NSArray arrayWithArray:remainingComments]];
}


- (void)photoPagesController:(EBPhotoPagesController *)controller
         didDeleteTagPopover:(EBTagPopover *)tagPopover
              inPhotoAtIndex:(NSInteger)index
{
    ViolationPhoto *photo = self.violationPhotos[index];
    NSMutableArray *remainingTags = [NSMutableArray arrayWithArray:photo.tags];
    id<EBPhotoTagProtocol> tagData = [tagPopover dataSource];
    [remainingTags removeObject:tagData];
    [photo setTags:[NSArray arrayWithArray:remainingTags]];
}

- (void)photoPagesController:(EBPhotoPagesController *)photoPagesController
       didDeletePhotoAtIndex:(NSInteger)index
{
    NSLog(@"Delete photo at index %li", (long)index);
//    ViolationPhoto *deletedPhoto = self.violationPhotos[index];
//    NSMutableArray *remainingPhotos = [NSMutableArray arrayWithArray:self.violationPhotos];
//    [remainingPhotos removeObject:deletedPhoto];
    [self.violationPhotos removeObjectAtIndex:index];
    [self deleteImageAtIndex:index];
}

- (void)photoPagesController:(EBPhotoPagesController *)photoPagesController
         didAddNewTagAtPoint:(CGPoint)tagLocation
                    withText:(NSString *)tagText
             forPhotoAtIndex:(NSInteger)index
                     tagInfo:(NSDictionary *)tagInfo
{
    NSLog(@"add new tag %@", tagText);
    
    ViolationPhoto *photo = self.violationPhotos[index];
    
    PhotoTag *newTag = [PhotoTag tagWithProperties:@{
                                                   @"tagPosition" : [NSValue valueWithCGPoint:tagLocation],
                                                   @"tagText" : tagText}];
    
    NSMutableArray *mutableTags = [NSMutableArray arrayWithArray:photo.tags];
    [mutableTags addObject:newTag];
    
    [photo setTags:[NSArray arrayWithArray:mutableTags]];
    
}


- (void)photoPagesController:(EBPhotoPagesController *)controller
              didPostComment:(NSString *)comment
             forPhotoAtIndex:(NSInteger)index
{
    NSString *user = @"Guest User";
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        if ([currentUser.username isEqualToString:@"hunaid@hotmail.com"]) {
            user = @"Hunaid Hussain";
        } else if ([currentUser.username isEqualToString:@"melo.nicolas@gmail.com"]) {
            user = @"Nicolas Melo";
        } else if ([currentUser.username isEqualToString:@"rosejonescolour@yahoo.com"]) {
            user = @"Rose Jones";
        } else if ([currentUser.username isEqualToString:@"test@gmail.com"]) {
            user = @"Test Bot";
        } else {
            user = currentUser.username;
        }

    }
    
    PhotoComment *newComment = [PhotoComment
                               commentWithProperties:@{@"commentText": comment,
                                                       @"commentDate": [NSDate date],
                                                       @"authorImage": [UIImage imageNamed:@"ic_reports_fullname"],
                                                       @"authorName" : user}];
    [newComment setUserCreated:YES];
    
    ViolationPhoto *photo = self.violationPhotos[index];
    [photo addComment:newComment];
    
    [controller setComments:photo.comments forPhotoAtIndex:index];
}


#pragma mark - User Permissions

- (BOOL)photoPagesController:(EBPhotoPagesController *)photoPagesController shouldAllowTaggingForPhotoAtIndex:(NSInteger)index
{
    if(!self.violationPhotos.count){
        return NO;
    }
    NSLog(@"tagging enabled");
    return YES;
}

- (BOOL)photoPagesController:(EBPhotoPagesController *)controller
 shouldAllowDeleteForComment:(id<EBPhotoCommentProtocol>)comment
             forPhotoAtIndex:(NSInteger)index
{
    //We assume all comment objects used in the demo are of type DEMOComment
    PhotoComment *demoComment = (PhotoComment *)comment;
    
    if(demoComment.isUserCreated){
        //Demo user can only delete his or her own comments.
        return YES;
    }
    
    return NO;
}


- (BOOL)photoPagesController:(EBPhotoPagesController *)photoPagesController shouldAllowCommentingForPhotoAtIndex:(NSInteger)index
{
    if(!self.violationPhotos.count){
        return NO;
    }
    NSLog(@"commenting enabled");

    return YES;
}


- (BOOL)photoPagesController:(EBPhotoPagesController *)photoPagesController shouldAllowActivitiesForPhotoAtIndex:(NSInteger)index
{
    if(!self.violationPhotos.count){
        return NO;
    }
    return NO;
//    DEMOPhoto *photo = (DEMOPhoto *)self.photos[index];
//    if(photo.disabledActivities){
//        return NO;
//    } else {
//        return YES;
//    }
}

- (BOOL)photoPagesController:(EBPhotoPagesController *)photoPagesController shouldAllowMiscActionsForPhotoAtIndex:(NSInteger)index
{
    return NO;
}

- (BOOL)photoPagesController:(EBPhotoPagesController *)photoPagesController shouldAllowDeleteForPhotoAtIndex:(NSInteger)index
{
    return YES;
}





- (BOOL)photoPagesController:(EBPhotoPagesController *)photoPagesController
     shouldAllowDeleteForTag:(EBTagPopover *)tagPopover
              inPhotoAtIndex:(NSInteger)index
{
    if(!self.violationPhotos.count){
        return NO;
    }
    
    return YES;
}




- (BOOL)photoPagesController:(EBPhotoPagesController *)photoPagesController
    shouldAllowEditingForTag:(EBTagPopover *)tagPopover
              inPhotoAtIndex:(NSInteger)index
{
    if(!self.violationPhotos.count){
        return NO;
    }
    
    if(index > 0){
        return YES;
    }
    
    return NO;
}


- (BOOL)photoPagesController:(EBPhotoPagesController *)photoPagesController shouldAllowReportForPhotoAtIndex:(NSInteger)index
{
    return NO;
}


#pragma mark - EBPPhotoPagesDelegate


- (void)photoPagesControllerDidDismiss:(EBPhotoPagesController *)photoPagesController
{
    NSLog(@"Finished using %@", photoPagesController);
}

@end
